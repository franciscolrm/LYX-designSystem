# ─────────────────────────────────────────────────────────────
#  Lyx Design System — instalador remoto (Windows PowerShell)
#
#  Uso (1 linha no terminal, sem clonar o repo):
#    irm https://raw.githubusercontent.com/franciscolrm/LYX-designSystem/main/install.ps1 | iex
#    lyx apply .\meu-projeto
#    lyx init meu-novo-projeto
#
#  Após o `iex`, a função `lyx` fica disponível na sessão atual.
# ─────────────────────────────────────────────────────────────

function lyx {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory=$true, Position=0)]
    [ValidateSet('apply','init','help')]
    [string]$Command,

    [Parameter(Position=1)]
    [string]$Target,

    [string]$Ref = 'main',
    [switch]$DryRun,
    [switch]$NoBackup
  )

  if ($Command -eq 'help') {
    Write-Host @"
Lyx Design System — instalador remoto

Comandos:
  lyx apply <caminho>   Aplica o design system em projeto Next.js existente
  lyx init  <nome>      Cria projeto Next.js novo já com design system

Flags:
  -Ref <branch|tag>     Versão do repo (default: main)
  -DryRun               Simula, não escreve nada
  -NoBackup             Não cria backup dos arquivos sobrescritos

Exemplos:
  lyx apply .\meu-projeto
  lyx init meu-novo-projeto -Ref v1.0.0
"@
    return
  }

  if (-not $Target) {
    Write-Error "'$Command' requer caminho/nome do projeto."
    return
  }

  $repo = 'franciscolrm/LYX-designSystem'

  foreach ($c in @('npm','tar')) {
    if (-not (Get-Command $c -ErrorAction SilentlyContinue)) {
      Write-Error "'$c' não encontrado no PATH."
      return
    }
  }

  $tmp = Join-Path $env:TEMP "lyx-ds-$([guid]::NewGuid().ToString('N'))"
  New-Item -ItemType Directory -Path $tmp | Out-Null

  try {
    Write-Host "▶ Baixando Lyx Design System ($Ref)..."
    $url = "https://codeload.github.com/$repo/tar.gz/refs/heads/$Ref"
    $tarPath = Join-Path $tmp 'ds.tar.gz'
    try {
      Invoke-WebRequest -Uri $url -OutFile $tarPath -UseBasicParsing -ErrorAction Stop
    } catch {
      $url = "https://codeload.github.com/$repo/tar.gz/refs/tags/$Ref"
      try {
        Invoke-WebRequest -Uri $url -OutFile $tarPath -UseBasicParsing -ErrorAction Stop
      } catch {
        Write-Error "Ref '$Ref' não encontrada."
        return
      }
    }

    & tar -xzf $tarPath -C $tmp
    if ($LASTEXITCODE -ne 0) { Write-Error "Falha ao extrair tarball."; return }

    $srcDir = Get-ChildItem -Path $tmp -Directory | Where-Object { $_.Name -like "*-$Ref" } | Select-Object -First 1
    if (-not $srcDir) { Write-Error "Extração falhou."; return }
    $srcPath = $srcDir.FullName
    Write-Host "  ✓ Baixado e extraído em tmp"

    $extraArgs = @()
    if ($DryRun)   { $extraArgs += '-DryRun' }
    if ($NoBackup) { $extraArgs += '-NoBackup' }

    switch ($Command) {
      'init' {
        if (Test-Path $Target) { Write-Error "'$Target' já existe."; return }
        Write-Host "▶ Criando projeto Next.js: $Target"
        & npx --yes create-next-app@latest $Target `
          --typescript --tailwind --eslint --app --src-dir `
          --import-alias "@/*" --use-npm --no-turbopack
        if ($LASTEXITCODE -ne 0) { Write-Error "create-next-app falhou."; return }
        & powershell -ExecutionPolicy Bypass -File (Join-Path $srcPath 'apply-design-system.ps1') `
          -Target $Target -From $srcPath @extraArgs
      }
      'apply' {
        if (-not (Test-Path $Target -PathType Container)) {
          Write-Error "Pasta '$Target' não encontrada."; return
        }
        & powershell -ExecutionPolicy Bypass -File (Join-Path $srcPath 'apply-design-system.ps1') `
          -Target $Target -From $srcPath @extraArgs
      }
    }

    Write-Host ""
    Write-Host "✓ Concluído."
  }
  finally {
    Remove-Item -Path $tmp -Recurse -Force -ErrorAction SilentlyContinue
  }
}

Write-Host "Função 'lyx' carregada. Use: lyx help" -ForegroundColor Green
