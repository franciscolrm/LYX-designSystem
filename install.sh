#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────
#  Lyx Design System — instalador remoto (macOS / Linux / Git-Bash)
#
#  Uso (1 linha no terminal, sem clonar o repo):
#    curl -fsSL https://raw.githubusercontent.com/franciscolrm/LYX-designSystem/main/install.sh | bash -s -- apply ./meu-projeto
#    curl -fsSL https://raw.githubusercontent.com/franciscolrm/LYX-designSystem/main/install.sh | bash -s -- init meu-novo-projeto
#
#  Flags opcionais:
#    --ref <branch|tag>   Versão do repo a baixar (default: main)
#    --dry-run            Mostra o que mudaria, sem aplicar
#    --no-backup          Desativa backup automático
# ─────────────────────────────────────────────────────────────

set -e

REPO="franciscolrm/LYX-designSystem"
REF="main"
CMD=""
TARGET=""
EXTRA_ARGS=()

usage() {
  cat <<EOF
Lyx Design System — instalador remoto

Comandos:
  apply <caminho>     Aplica o design system em projeto Next.js existente
  init  <nome>        Cria projeto Next.js novo já com design system

Flags:
  --ref <branch|tag>  Versão do repo (default: main)
  --dry-run           Simula, não escreve nada
  --no-backup         Não cria backup dos arquivos sobrescritos

Exemplos:
  bash install.sh apply ./meu-projeto
  bash install.sh init meu-novo-projeto --ref v1.0.0
EOF
}

# ── Parse args ───────────────────────────────────────────────
if [ $# -eq 0 ]; then usage; exit 0; fi

CMD="$1"; shift
case "$CMD" in
  apply|init) ;;
  -h|--help) usage; exit 0 ;;
  *) echo "Erro: comando inválido '$CMD'"; usage; exit 1 ;;
esac

if [ $# -lt 1 ]; then
  echo "Erro: '$CMD' requer um argumento (caminho ou nome do projeto)."
  usage; exit 1
fi
TARGET="$1"; shift

while [ $# -gt 0 ]; do
  case "$1" in
    --ref) REF="$2"; shift 2 ;;
    --dry-run|--no-backup) EXTRA_ARGS+=("$1"); shift ;;
    *) echo "Erro: flag desconhecida '$1'"; exit 1 ;;
  esac
done

# ── Pré-checagens ────────────────────────────────────────────
for cmd in curl tar npm; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Erro: '$cmd' não encontrado no PATH."
    exit 1
  fi
done

# ── Baixar tarball ───────────────────────────────────────────
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

URL="https://codeload.github.com/${REPO}/tar.gz/refs/heads/${REF}"
echo "▶ Baixando Lyx Design System ($REF)..."
if ! curl -fsSL "$URL" -o "$TMP/ds.tar.gz"; then
  # tenta tag em vez de branch
  URL="https://codeload.github.com/${REPO}/tar.gz/refs/tags/${REF}"
  curl -fsSL "$URL" -o "$TMP/ds.tar.gz" || { echo "Erro: ref '$REF' não encontrada."; exit 1; }
fi

tar -xzf "$TMP/ds.tar.gz" -C "$TMP"
SRC_DIR="$(find "$TMP" -maxdepth 1 -type d -name "*-${REF}" | head -1)"
if [ -z "$SRC_DIR" ] || [ ! -d "$SRC_DIR" ]; then
  echo "Erro: extração falhou."; exit 1
fi
echo "  ✓ Baixado e extraído em tmp"

# ── Executar comando ─────────────────────────────────────────
case "$CMD" in
  init)
    if [ -e "$TARGET" ]; then
      echo "Erro: '$TARGET' já existe."; exit 1
    fi
    echo "▶ Criando projeto Next.js: $TARGET"
    npx --yes create-next-app@latest "$TARGET" \
      --typescript --tailwind --eslint --app --src-dir \
      --import-alias "@/*" --use-npm --no-turbopack
    bash "$SRC_DIR/apply-design-system.sh" "$TARGET" --from "$SRC_DIR" "${EXTRA_ARGS[@]}"
    ;;
  apply)
    if [ ! -d "$TARGET" ]; then
      echo "Erro: pasta '$TARGET' não encontrada."; exit 1
    fi
    bash "$SRC_DIR/apply-design-system.sh" "$TARGET" --from "$SRC_DIR" "${EXTRA_ARGS[@]}"
    ;;
esac

echo ""
echo "✓ Concluído."
