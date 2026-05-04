#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────
#  Lyx Design System — aplicar em projeto Next.js
#  Uso: bash apply-design-system.sh <caminho-do-projeto> [opções]
#
#  Opções:
#    --from <dir>    Pasta de origem do design system (default: pasta do script)
#    --dry-run       Mostra o que mudaria, sem escrever
#    --no-backup     Não cria backup .lyx-backup-<timestamp>/
# ─────────────────────────────────────────────────────────────

set -e

DS_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET=""
DRY_RUN=0
DO_BACKUP=1

# ── Parse args ───────────────────────────────────────────────
while [ $# -gt 0 ]; do
  case "$1" in
    --from) DS_DIR="$2"; shift 2 ;;
    --dry-run) DRY_RUN=1; shift ;;
    --no-backup) DO_BACKUP=0; shift ;;
    -h|--help)
      echo "Uso: bash apply-design-system.sh <caminho> [--from <dir>] [--dry-run] [--no-backup]"
      exit 0 ;;
    -*) echo "Erro: flag desconhecida '$1'"; exit 1 ;;
    *) TARGET="$1"; shift ;;
  esac
done

run() { if [ $DRY_RUN -eq 1 ]; then echo "  [dry-run] $*"; else eval "$@"; fi; }

# ── Validação ────────────────────────────────────────────────
if [ -z "$TARGET" ]; then
  echo "Erro: informe o caminho do projeto."
  exit 1
fi
if [ ! -d "$TARGET" ]; then echo "Erro: pasta '$TARGET' não encontrada."; exit 1; fi
if [ ! -f "$TARGET/package.json" ]; then echo "Erro: '$TARGET' sem package.json."; exit 1; fi
if ! command -v npm >/dev/null 2>&1; then echo "Erro: npm não encontrado."; exit 1; fi
if ! grep -q '"next"' "$TARGET/package.json"; then
  echo "Erro: '$TARGET' não é projeto Next.js."; exit 1
fi
if ! grep -q '"tailwindcss"' "$TARGET/package.json"; then
  echo "Erro: Tailwind CSS não encontrado no package.json."; exit 1
fi

# Bloqueia Tailwind v3 (DS é v4)
TW_VER=$(grep -oE '"tailwindcss"\s*:\s*"[^"]+"' "$TARGET/package.json" | head -1 | grep -oE '[0-9]+' | head -1 || echo "")
if [ -n "$TW_VER" ] && [ "$TW_VER" -lt 4 ]; then
  echo "Erro: Lyx Design System requer Tailwind CSS v4. Projeto usa v$TW_VER."
  echo "Migre para Tailwind v4 antes de aplicar (https://tailwindcss.com/docs/upgrade-guide)."
  exit 1
fi

# Detecta estrutura
if [ -d "$TARGET/src/app" ]; then
  APP_DIR="$TARGET/src/app"; COMP_DIR="$TARGET/src/components/ui"
  LIB_DIR="$TARGET/src/lib"; STRUCTURE="src/"
elif [ -d "$TARGET/app" ]; then
  APP_DIR="$TARGET/app"; COMP_DIR="$TARGET/components/ui"
  LIB_DIR="$TARGET/lib"; STRUCTURE="raiz"
else
  echo "Erro: App Router não encontrado (esperado src/app ou app)."; exit 1
fi

# Detecta backend (apenas avisa, não toca)
BACKEND_HITS=""
[ -d "$APP_DIR/api" ] && BACKEND_HITS+="  • $APP_DIR/api (rotas API)\n"
[ -d "$TARGET/prisma" ] && BACKEND_HITS+="  • $TARGET/prisma\n"
[ -d "$TARGET/drizzle" ] && BACKEND_HITS+="  • $TARGET/drizzle\n"
[ -d "$TARGET/server" ] && BACKEND_HITS+="  • $TARGET/server\n"

echo ""
echo "▶ Aplicando Lyx Design System em: $TARGET"
echo "  Estrutura: $STRUCTURE"
echo "  Origem:    $DS_DIR"
[ $DRY_RUN -eq 1 ] && echo "  Modo:      DRY-RUN (nada será escrito)"
echo ""

if [ -n "$BACKEND_HITS" ]; then
  echo "ℹ Backend detectado (não será tocado):"
  echo -e "$BACKEND_HITS"
fi

# ── Backup ───────────────────────────────────────────────────
if [ $DO_BACKUP -eq 1 ] && [ $DRY_RUN -eq 0 ]; then
  TS=$(date +%Y%m%d-%H%M%S)
  BACKUP="$TARGET/.lyx-backup-$TS"
  mkdir -p "$BACKUP"
  [ -f "$APP_DIR/globals.css" ] && cp "$APP_DIR/globals.css" "$BACKUP/" 2>/dev/null || true
  [ -f "$APP_DIR/layout.tsx" ]  && cp "$APP_DIR/layout.tsx"  "$BACKUP/" 2>/dev/null || true
  [ -d "$COMP_DIR" ]            && cp -r "$COMP_DIR" "$BACKUP/components-ui" 2>/dev/null || true
  [ -f "$LIB_DIR/utils.ts" ]    && cp "$LIB_DIR/utils.ts" "$BACKUP/" 2>/dev/null || true
  echo "[1/6] Backup criado em $BACKUP"
else
  echo "[1/6] Backup pulado"
fi

# ── Dependências ─────────────────────────────────────────────
echo "[2/6] Instalando dependências..."
if [ $DRY_RUN -eq 0 ]; then
  ( cd "$TARGET" && npm install tailwind-merge clsx class-variance-authority radix-ui lucide-react recharts tw-animate-css --save 2>&1 | tail -3 )
else
  echo "  [dry-run] npm install tailwind-merge clsx class-variance-authority radix-ui lucide-react recharts tw-animate-css"
fi

# ── Diretórios ───────────────────────────────────────────────
echo "[3/6] Preparando diretórios..."
run mkdir -p "\"$COMP_DIR\"" "\"$LIB_DIR\"" "\"$TARGET/public\""

# ── Copiar arquivos ──────────────────────────────────────────
echo "[4/6] Copiando tokens e componentes..."
run cp "\"$DS_DIR/tokens/globals.css\"" "\"$APP_DIR/globals.css\""
run cp -r "\"$DS_DIR/components/ui/.\"" "\"$COMP_DIR/\""
run cp "\"$DS_DIR/lib/utils.ts\"" "\"$LIB_DIR/utils.ts\""
run cp "\"$DS_DIR/assets/lyx-logo.svg\"" "\"$TARGET/public/lyx-logo.svg\""
[ -f "$DS_DIR/assets/lyx-logo.png" ] && run cp "\"$DS_DIR/assets/lyx-logo.png\"" "\"$TARGET/public/lyx-logo.png\""

# ── Layout ───────────────────────────────────────────────────
echo "[5/6] Atualizando layout.tsx..."
LAYOUT="$APP_DIR/layout.tsx"
if [ -f "$LAYOUT" ]; then
  if [ $DRY_RUN -eq 0 ]; then
    sed -i.bak 's/import { Geist, Geist_Mono } from "next\/font\/google"/import { Inter, Geist_Mono } from "next\/font\/google"/' "$LAYOUT"
    sed -i.bak 's/import { Geist } from "next\/font\/google"/import { Inter } from "next\/font\/google"/' "$LAYOUT"
    sed -i.bak 's/const geistSans = Geist({/const inter = Inter({/' "$LAYOUT"
    sed -i.bak 's/variable: "--font-geist-sans"/variable: "--font-inter"/' "$LAYOUT"
    sed -i.bak 's/${geistSans\.variable}/${inter.variable}/g' "$LAYOUT"
    sed -i.bak 's/bg-\[#[0-9a-fA-F]*\]/bg-background/g' "$LAYOUT"
    rm -f "$LAYOUT.bak"
    echo "  ✓ layout.tsx atualizado"
  else
    echo "  [dry-run] ajustes em $LAYOUT (Geist→Inter, --font-inter, bg-background)"
  fi
else
  echo "  ⚠ layout.tsx não encontrado — atualize manualmente (veja README)"
fi

# ── Relatório de cores hardcoded ─────────────────────────────
echo "[6/6] Gerando relatório de migração..."
REPORT="$TARGET/lyx-migration-report.md"
if [ $DRY_RUN -eq 0 ]; then
  {
    echo "# Lyx Migration Report"
    echo ""
    echo "Data: $(date)"
    echo ""
    echo "## Cores hardcoded encontradas"
    echo ""
    echo "Substitua por tokens (\`bg-background\`, \`text-foreground\`, etc.)."
    echo ""
    echo '```'
    grep -RIn -E 'bg-\[#|text-\[#|border-\[#|#[0-9a-fA-F]{3,8}\b' \
      --include="*.tsx" --include="*.ts" --include="*.css" \
      --exclude-dir=node_modules --exclude-dir=.next --exclude-dir=.lyx-backup-* \
      "$TARGET" 2>/dev/null | head -200 || echo "(nenhuma)"
    echo '```'
    echo ""
    [ -n "$BACKEND_HITS" ] && { echo "## Backend (não tocado)"; echo ""; echo -e "$BACKEND_HITS"; }
  } > "$REPORT"
  echo "  ✓ $REPORT"
else
  echo "  [dry-run] relatório seria gerado em $REPORT"
fi

echo ""
echo "✓ Concluído!"
echo "  Próximo passo: cd $TARGET && npm run dev"
