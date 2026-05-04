# ─────────────────────────────────────────────────────────────
#  Lyx Design System — aplicar em projeto Next.js (Windows PowerShell)
#  Uso: .\apply-design-system.ps1 -Target <caminho> [-From <dir>] [-DryRun] [-NoBackup]
# ─────────────────────────────────────────────────────────────

[CmdletBinding()]
param(
  [Parameter(Mandatory=$true, Position=0)]
  [string]$Target,
  [string]$From = $PSScriptRoot,
  [switch]$DryRun,
  [switch]$NoBackup
)

$ErrorActionPreference = 'Stop'
$DsDir = (Resolve-Path $From).Path

function Run-Cmd {
  param([scriptblock]$Block, [string]$Label)
  if ($DryRun) { Write-Host "  [dry-run] $Label" } else { & $Block }
}

# ── Validação ────────────────────────────────────────────────
if (-not (Test-Path $Target -PathType Container)) { throw "Pasta '$Target' não encontrada." }
$Target = (Resolve-Path $Target).Path

$pkgPath = Join-Path $Target 'package.json'
if (-not (Test-Path $pkgPath)) { throw "'$Target' sem package.json." }
if (-not (Get-Command npm -ErrorAction SilentlyContinue)) { throw "npm não encontrado." }

$pkgRaw = Get-Content $pkgPath -Raw
if ($pkgRaw -notmatch '"next"')        { throw "'$Target' não é projeto Next.js." }
if ($pkgRaw -notmatch '"tailwindcss"') { throw "Tailwind CSS não encontrado no package.json." }

# Bloqueia Tailwind v3
if ($pkgRaw -match '"tailwindcss"\s*:\s*"[^0-9]*([0-9]+)') {
  $twMajor = [int]$Matches[1]
  if ($twMajor -lt 4) {
    throw "Lyx Design System requer Tailwind CSS v4. Projeto usa v$twMajor. Migre antes de aplicar."
  }
}

# Estrutura
if (Test-Path (Join-Path $Target 'src/app')) {
  $appDir = Join-Path $Target 'src/app'
  $compDir = Join-Path $Target 'src/components/ui'
  $libDir = Join-Path $Target 'src/lib'
  $structure = 'src/'
} elseif (Test-Path (Join-Path $Target 'app')) {
  $appDir = Join-Path $Target 'app'
  $compDir = Join-Path $Target 'components/ui'
  $libDir = Join-Path $Target 'lib'
  $structure = 'raiz'
} else {
  throw "App Router não encontrado (esperado src/app ou app)."
}

# Backend
$backendHits = @()
if (Test-Path (Join-Path $appDir 'api'))     { $backendHits += "  • $appDir\api (rotas API)" }
if (Test-Path (Join-Path $Target 'prisma'))  { $backendHits += "  • $Target\prisma" }
if (Test-Path (Join-Path $Target 'drizzle')) { $backendHits += "  • $Target\drizzle" }
if (Test-Path (Join-Path $Target 'server'))  { $backendHits += "  • $Target\server" }

Write-Host ""
Write-Host "▶ Aplicando Lyx Design System em: $Target"
Write-Host "  Estrutura: $structure"
Write-Host "  Origem:    $DsDir"
if ($DryRun) { Write-Host "  Modo:      DRY-RUN (nada será escrito)" }
Write-Host ""

if ($backendHits.Count -gt 0) {
  Write-Host "ℹ Backend detectado (não será tocado):"
  $backendHits | ForEach-Object { Write-Host $_ }
  Write-Host ""
}

# ── Backup ───────────────────────────────────────────────────
if (-not $NoBackup -and -not $DryRun) {
  $ts = Get-Date -Format 'yyyyMMdd-HHmmss'
  $backup = Join-Path $Target ".lyx-backup-$ts"
  New-Item -ItemType Directory -Path $backup -Force | Out-Null
  $globalsCss = Join-Path $appDir 'globals.css'
  $layoutTsx  = Join-Path $appDir 'layout.tsx'
  $utilsTs    = Join-Path $libDir 'utils.ts'
  if (Test-Path $globalsCss) { Copy-Item $globalsCss $backup -Force }
  if (Test-Path $layoutTsx)  { Copy-Item $layoutTsx  $backup -Force }
  if (Test-Path $compDir)    { Copy-Item $compDir (Join-Path $backup 'components-ui') -Recurse -Force }
  if (Test-Path $utilsTs)    { Copy-Item $utilsTs   $backup -Force }
  Write-Host "[1/6] Backup criado em $backup"
} else {
  Write-Host "[1/6] Backup pulado"
}

# ── Dependências ─────────────────────────────────────────────
Write-Host "[2/6] Instalando dependências..."
if (-not $DryRun) {
  Push-Location $Target
  try {
    & npm install tailwind-merge clsx class-variance-authority radix-ui lucide-react recharts tw-animate-css --save | Select-Object -Last 3
  } finally { Pop-Location }
} else {
  Write-Host "  [dry-run] npm install tailwind-merge clsx class-variance-authority radix-ui lucide-react recharts tw-animate-css"
}

# ── Diretórios ───────────────────────────────────────────────
Write-Host "[3/6] Preparando diretórios..."
foreach ($d in @($compDir, $libDir, (Join-Path $Target 'public'))) {
  Run-Cmd -Label "mkdir $d" -Block { New-Item -ItemType Directory -Path $d -Force | Out-Null }
}

# ── Copiar arquivos ──────────────────────────────────────────
Write-Host "[4/6] Copiando tokens e componentes..."
$tokensSrc = Join-Path $DsDir 'tokens/globals.css'
$compSrc   = Join-Path $DsDir 'components/ui'
$utilsSrc  = Join-Path $DsDir 'lib/utils.ts'
$svgSrc    = Join-Path $DsDir 'assets/lyx-logo.svg'
$pngSrc    = Join-Path $DsDir 'assets/lyx-logo.png'

Run-Cmd -Label "copy globals.css" -Block { Copy-Item $tokensSrc (Join-Path $appDir 'globals.css') -Force }
Run-Cmd -Label "copy components/ui" -Block { Copy-Item (Join-Path $compSrc '*') $compDir -Recurse -Force }
Run-Cmd -Label "copy utils.ts"   -Block { Copy-Item $utilsSrc (Join-Path $libDir 'utils.ts') -Force }
Run-Cmd -Label "copy lyx-logo.svg" -Block { Copy-Item $svgSrc (Join-Path $Target 'public/lyx-logo.svg') -Force }
if (Test-Path $pngSrc) {
  Run-Cmd -Label "copy lyx-logo.png" -Block { Copy-Item $pngSrc (Join-Path $Target 'public/lyx-logo.png') -Force }
}

# ── Layout ───────────────────────────────────────────────────
Write-Host "[5/6] Atualizando layout.tsx..."
$layout = Join-Path $appDir 'layout.tsx'
if (Test-Path $layout) {
  if (-not $DryRun) {
    $content = Get-Content $layout -Raw
    $content = $content -replace 'import \{ Geist, Geist_Mono \} from "next/font/google"', 'import { Inter, Geist_Mono } from "next/font/google"'
    $content = $content -replace 'import \{ Geist \} from "next/font/google"', 'import { Inter } from "next/font/google"'
    $content = $content -replace 'const geistSans = Geist\(\{', 'const inter = Inter({'
    $content = $content -replace 'variable: "--font-geist-sans"', 'variable: "--font-inter"'
    $content = $content -replace '\$\{geistSans\.variable\}', '${inter.variable}'
    $content = $content -replace 'bg-\[#[0-9a-fA-F]+\]', 'bg-background'
    Set-Content $layout $content -NoNewline -Encoding utf8
    Write-Host "  ✓ layout.tsx atualizado"
  } else {
    Write-Host "  [dry-run] ajustes em $layout (Geist→Inter, --font-inter, bg-background)"
  }
} else {
  Write-Host "  ⚠ layout.tsx não encontrado — atualize manualmente"
}

# ── Relatório ────────────────────────────────────────────────
Write-Host "[6/6] Gerando relatório de migração..."
$report = Join-Path $Target 'lyx-migration-report.md'
if (-not $DryRun) {
  $hits = @()
  $exclude = @('node_modules','.next','dist','.git')
  Get-ChildItem -Path $Target -Recurse -File -Include *.tsx,*.ts,*.css -ErrorAction SilentlyContinue |
    Where-Object {
      $p = $_.FullName
      -not ($exclude | Where-Object { $p -match "[\\/]$_[\\/]" }) -and
      $p -notmatch '\.lyx-backup-'
    } |
    Select-Object -First 5000 |
    ForEach-Object {
      $f = $_.FullName
      Select-String -Path $f -Pattern 'bg-\[#|text-\[#|border-\[#|#[0-9a-fA-F]{3,8}\b' -ErrorAction SilentlyContinue |
        ForEach-Object { $hits += "$($_.Path):$($_.LineNumber): $($_.Line.Trim())" }
    }

  $body = @()
  $body += "# Lyx Migration Report"
  $body += ""
  $body += "Data: $(Get-Date)"
  $body += ""
  $body += "## Cores hardcoded encontradas"
  $body += ""
  $body += 'Substitua por tokens (`bg-background`, `text-foreground`, etc.).'
  $body += ""
  $body += '```'
  if ($hits.Count -gt 0) { $body += ($hits | Select-Object -First 200) } else { $body += "(nenhuma)" }
  $body += '```'
  if ($backendHits.Count -gt 0) {
    $body += ""
    $body += "## Backend (não tocado)"
    $body += ""
    $body += $backendHits
  }
  Set-Content $report ($body -join "`r`n") -Encoding utf8
  Write-Host "  ✓ $report"
} else {
  Write-Host "  [dry-run] relatório seria gerado em $report"
}

Write-Host ""
Write-Host "✓ Concluído!"
Write-Host "  Próximo passo: cd $Target ; npm run dev"
