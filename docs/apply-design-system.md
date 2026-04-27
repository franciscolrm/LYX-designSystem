# Guia de Aplicacao - Lyx Design System

Este documento explica como aplicar o **Lyx Design System** em um projeto Next.js existente usando o script `apply-design-system.sh`.

O objetivo do script e transformar um projeto Next.js recem-criado em uma base visual padronizada para dashboards, sistemas internos e produtos de BI da Lyx, copiando tokens, componentes, utilitarios e assets essenciais.

---

## Quando usar

Use este script quando voce quiser iniciar um novo projeto Next.js ja conectado ao padrao visual da Lyx.

Ele e indicado para:

- dashboards administrativos;
- paineis de BI;
- ferramentas internas;
- projetos Next.js com App Router;
- bases criadas com `create-next-app`.

---

## Pre-requisitos

Antes de executar o script, garanta que voce tenha:

- Node.js instalado;
- npm disponivel no terminal;
- um projeto Next.js ja criado;
- um arquivo `package.json` na raiz do projeto alvo;
- permissao para instalar dependencias e copiar arquivos no projeto alvo.

Recomendacao de criacao do projeto:

```bash
npx create-next-app@latest meu-projeto --typescript --tailwind --eslint --app --src-dir --import-alias "@/*"
```

---

## Como executar

A partir da pasta do repositorio `lyx-design-system`, rode:

```bash
bash apply-design-system.sh ../meu-projeto
```

Exemplo:

```bash
bash apply-design-system.sh ../dashboard-comercial
```

Depois da aplicacao:

```bash
cd ../dashboard-comercial
npm run dev
```

---

## O que o script faz

O script executa quatro etapas principais.

### 1. Valida o projeto alvo

Antes de alterar qualquer arquivo, ele verifica se:

- o caminho do projeto foi informado;
- a pasta existe;
- existe um `package.json` no projeto alvo.

Se alguma validacao falhar, o script interrompe a execucao e mostra uma mensagem de erro.

### 2. Instala dependencias

O script entra no projeto alvo e instala as bibliotecas usadas pelos componentes do design system:

```bash
npm install tailwind-merge clsx class-variance-authority radix-ui lucide-react recharts tw-animate-css --save
```

Essas dependencias cobrem composicao de classes, variantes de componentes, primitivas acessiveis, icones, graficos e animacoes.

### 3. Detecta a estrutura do projeto

O script identifica automaticamente se o projeto usa estrutura com `src/`:

```txt
src/app
src/components/ui
src/lib
```

Ou estrutura na raiz:

```txt
app
components/ui
lib
```

Com base nisso, ele define os destinos corretos para copiar os arquivos.

### 4. Copia os arquivos do design system

Os principais arquivos copiados sao:

| Origem | Destino |
| --- | --- |
| `tokens/globals.css` | `app/globals.css` ou `src/app/globals.css` |
| `components/ui/*` | `components/ui/` ou `src/components/ui/` |
| `lib/utils.ts` | `lib/utils.ts` ou `src/lib/utils.ts` |
| `assets/lyx-logo.svg` | `public/lyx-logo.svg` |
| `assets/lyx-logo.png` | `public/lyx-logo.png`, se existir |

### 5. Ajusta o `layout.tsx`

Quando encontra o arquivo `layout.tsx`, o script faz ajustes automaticos:

- troca `Geist` por `Inter` como fonte principal;
- altera a variavel CSS da fonte para `--font-inter`;
- atualiza o uso da variavel no `className`;
- troca backgrounds hardcoded no formato `bg-[#...]` por `bg-background`.

Se o arquivo `layout.tsx` nao existir, o script avisa que a atualizacao deve ser feita manualmente.

---

## Resultado esperado

Apos a execucao, o projeto alvo passa a ter:

- tokens globais do Lyx Design System;
- componentes UI reutilizaveis;
- helper `cn()` para composicao segura de classes;
- logos da Lyx na pasta `public`;
- layout preparado para usar a fonte Inter;
- base visual alinhada ao padrao de dashboards da Lyx.

Estrutura esperada em projetos com `src/`:

```txt
meu-projeto/
|-- public/
|   |-- lyx-logo.svg
|   `-- lyx-logo.png
|-- src/
|   |-- app/
|   |   |-- globals.css
|   |   `-- layout.tsx
|   |-- components/
|   |   `-- ui/
|   `-- lib/
|       `-- utils.ts
`-- package.json
```

---

## Checklist pos-instalacao

Depois de rodar o script, revise:

- se `npm run dev` inicia sem erro;
- se `globals.css` foi copiado para o diretorio correto;
- se os imports `@/components/ui/...` funcionam;
- se o logo aparece corretamente em `/public`;
- se o `layout.tsx` esta usando `Inter`;
- se o projeto usa `bg-background` e `text-foreground` no corpo da pagina.

---

## Troubleshooting

### Erro: informe o caminho do projeto

O script foi executado sem argumento.

Use:

```bash
bash apply-design-system.sh ../meu-projeto
```

### Erro: pasta nao encontrada

O caminho informado nao existe ou esta incorreto.

Confira o caminho relativo a partir da pasta `lyx-design-system`.

### Erro: sem package.json

O diretorio informado nao parece ser um projeto Node.js.

Verifique se voce passou o caminho da raiz do projeto Next.js.

### layout.tsx nao encontrado

O script conseguiu copiar os arquivos, mas nao encontrou o layout global.

Nesse caso, ajuste manualmente o arquivo `app/layout.tsx` ou `src/app/layout.tsx`.

### Componentes nao renderizam corretamente

Verifique se:

- o projeto esta usando Tailwind CSS;
- o arquivo `globals.css` importado no layout e o arquivo copiado pelo design system;
- as dependencias foram instaladas;
- o alias `@/*` esta configurado corretamente.

---

## Boas praticas

- Rode o script logo apos criar o projeto Next.js.
- Evite executar em projetos com componentes ja customizados sem revisar os arquivos sobrescritos.
- Versione o projeto antes da aplicacao para comparar as alteracoes.
- Use os tokens do design system em vez de cores hardcoded.
- Prefira componentes de `components/ui` antes de criar novos componentes base.

---

## Observacao importante

O script copia e sobrescreve alguns arquivos de destino, como `globals.css`, `utils.ts` e componentes dentro de `components/ui`.

Em projetos novos, isso e esperado. Em projetos existentes, revise o impacto antes de executar.
