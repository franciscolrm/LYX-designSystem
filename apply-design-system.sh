
#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────
#  Lyx Design System — aplicar em novo projeto Next.js
#  Uso: bash apply-design-system.sh <caminho-do-projeto>
#  Ex:  bash apply-design-system.sh ../meu-novo-dashboard
# ─────────────────────────────────────────────────────────────

set -e

DS_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET="$1"

# ── Validação ────────────────────────────────────────────────
if [ -z "$TARGET" ]; then
  echo "Erro: informe o caminho do projeto."
  echo "Uso: bash apply-design-system.sh <caminho-do-projeto>"
  exit 1
fi

if [ ! -d "$TARGET" ]; then
  echo "Erro: pasta '$TARGET' não encontrada."
  exit 1
fi

if [ ! -f "$TARGET/package.json" ]; then
  echo "Erro: '$TARGET' não é um projeto Node.js (sem package.json)."
  exit 1
fi

echo ""
echo "▶ Aplicando Lyx Design System em: $TARGET"
echo ""

# ── 1. Dependências ──────────────────────────────────────────
echo "[1/4] Instalando dependências..."
cd "$TARGET"
npm install tailwind-merge clsx class-variance-authority radix-ui lucide-react recharts tw-animate-css --save 2>&1 | tail -3
cd "$DS_DIR"
echo "      ✓ Dependências instaladas"

# ── 2. Detectar estrutura src/ ou raiz ───────────────────────
if [ -d "$TARGET/src/app" ]; then
  APP_DIR="$TARGET/src/app"
  COMP_DIR="$TARGET/src/components/ui"
  LIB_DIR="$TARGET/src/lib"
else
  APP_DIR="$TARGET/app"
  COMP_DIR="$TARGET/components/ui"
  LIB_DIR="$TARGET/lib"
fi

mkdir -p "$COMP_DIR" "$LIB_DIR" "$TARGET/public"

# ── 3. Copiar arquivos ───────────────────────────────────────
echo "[2/4] Copiando tokens e componentes..."

cp "$DS_DIR/tokens/globals.css"        "$APP_DIR/globals.css"
cp -r "$DS_DIR/components/ui/"*        "$COMP_DIR/"
cp "$DS_DIR/lib/utils.ts"              "$LIB_DIR/utils.ts"
cp "$DS_DIR/assets/lyx-logo.svg"       "$TARGET/public/lyx-logo.svg"

if [ -f "$DS_DIR/assets/lyx-logo.png" ]; then
  cp "$DS_DIR/assets/lyx-logo.png"     "$TARGET/public/lyx-logo.png"
fi

echo "      ✓ Arquivos copiados"

# ── 4. Atualizar layout.tsx ──────────────────────────────────
echo "[3/4] Atualizando layout.tsx..."

LAYOUT="$APP_DIR/layout.tsx"

if [ -f "$LAYOUT" ]; then
  # Troca Geist por Inter
  sed -i 's/import { Geist, Geist_Mono } from "next\/font\/google"/import { Inter, Geist_Mono } from "next\/font\/google"/' "$LAYOUT"
  sed -i 's/import { Geist } from "next\/font\/google"/import { Inter } from "next\/font\/google"/' "$LAYOUT"

  # Troca declaração da fonte sans
  sed -i 's/const geistSans = Geist({/const inter = Inter({/' "$LAYOUT"
  sed -i 's/variable: "--font-geist-sans"/variable: "--font-inter"/' "$LAYOUT"

  # Troca uso no className
  sed -i 's/${geistSans\.variable}/${inter.variable}/g' "$LAYOUT"

  # Troca bg hardcoded comum
  sed -i 's/bg-\[#[0-9a-fA-F]*\]/bg-background/g' "$LAYOUT"

  echo "      ✓ layout.tsx atualizado"
else
  echo "      ⚠ layout.tsx não encontrado — atualize manualmente (veja README)"
fi

# ── 5. Resumo ────────────────────────────────────────────────
echo "[4/4] Concluído!"
echo ""
echo "  Tokens:      $APP_DIR/globals.css"
echo "  Componentes: $COMP_DIR/"
echo "  Utils:       $LIB_DIR/utils.ts"
echo "  Assets:      $TARGET/public/"
echo ""
echo "  Próximo passo: cd $TARGET && npm run dev"
echo ""
