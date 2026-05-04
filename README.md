# Lyx Design System

Padrão de design para todos os projetos de dashboard e BI da Lyx Incorporadora.

---

## Como usar (1 linha no terminal — sem clonar o repo)

O instalador baixa apenas os arquivos necessários do GitHub (via tarball), aplica no seu projeto e limpa os temporários. Funciona em **macOS, Linux e Windows**.

### macOS / Linux / Git-Bash

```bash
# Aplicar em projeto Next.js existente
curl -fsSL https://raw.githubusercontent.com/franciscolrm/LYX-designSystem/main/install.sh | bash -s -- apply ./meu-projeto

# Criar projeto novo já com o design system
curl -fsSL https://raw.githubusercontent.com/franciscolrm/LYX-designSystem/main/install.sh | bash -s -- init meu-novo-projeto
```

### Windows (PowerShell)

```powershell
# Carrega a função `lyx` na sessão
irm https://raw.githubusercontent.com/franciscolrm/LYX-designSystem/main/install.ps1 | iex

# Aplicar em projeto existente
lyx apply .\meu-projeto

# Criar projeto novo
lyx init meu-novo-projeto
```

### Flags suportadas

| Flag (bash)        | Flag (PS)        | Descrição |
|--------------------|------------------|-----------|
| `--ref <tag>`      | `-Ref <tag>`     | Versão/branch do design system (default: `main`) |
| `--dry-run`        | `-DryRun`        | Simula a aplicação sem escrever arquivos |
| `--no-backup`      | `-NoBackup`      | Desativa backup automático |

### Dois cenários cobertos

1. **Projeto existente** (`apply`) — aplica o design system **sem mexer no backend**.
   - Detecta `app/api`, `prisma/`, `drizzle/`, `server/` → reporta mas **não toca**.
   - Bloqueia se Tailwind v3 estiver instalado (DS exige v4).
   - Cria backup em `.lyx-backup-<timestamp>/` antes de sobrescrever.
   - Gera `lyx-migration-report.md` listando cores hardcoded a migrar.
2. **Projeto novo** (`init`) — roda `create-next-app` com a stack padrão Lyx e aplica tudo.

### Pré-requisitos

- `npm` no PATH (Node 18+).
- `tar` e `curl` (macOS/Linux já têm; Windows 10+ tem `tar` nativo, `Invoke-WebRequest` faz o resto).
- Projeto alvo (modo `apply`) deve ter: Next.js App Router (`app/` ou `src/app/`) + Tailwind CSS v4.

---

## Estrutura do repositório

```
lyx-design-system/
├── tokens/globals.css            # Tokens CSS (cores, fontes, radius)
├── components/ui/                # Componentes copiáveis (button, card, sidebar, etc.)
├── lib/utils.ts                  # Helper cn()
├── assets/                       # Logos (svg/png)
├── docs/                         # Documentação visual e do aplicador
├── preview/                      # Projeto Next.js para visualizar o DS
├── install.sh                    # Bootstrap remoto (macOS/Linux/Git-Bash)
├── install.ps1                   # Bootstrap remoto (Windows PowerShell)
├── apply-design-system.sh        # Aplicador local (bash)
├── apply-design-system.ps1       # Aplicador local (PowerShell)
├── STACK.md
└── README.md
```

---

## Visualizar o design system

Para ver todos os tokens e componentes no browser:

```bash
cd preview
npm install
npm run dev
```

Acesse **http://localhost:3000/design-system**

---

## Uso local (clonando o repo)

Se preferir clonar o repo (ex: para desenvolver o próprio DS):

```bash
git clone https://github.com/franciscolrm/LYX-designSystem.git lyx-design-system
cd lyx-design-system

# bash
bash apply-design-system.sh ../meu-projeto [--dry-run] [--no-backup]

# PowerShell
.\apply-design-system.ps1 -Target ..\meu-projeto [-DryRun] [-NoBackup]
```

Documentação detalhada do aplicador: [`docs/apply-design-system.md`](docs/apply-design-system.md)

---

### Passo a passo manual (sem script)

#### 1. Criar o projeto Next.js

```bash
npx create-next-app@latest meu-projeto --typescript --tailwind --eslint --app --src-dir --import-alias "@/*"
cd meu-projeto
```

#### 2. Instalar dependências

```bash
npm install tailwind-merge clsx class-variance-authority radix-ui lucide-react recharts tw-animate-css
```

#### 3. Copiar os arquivos do design system

| Origem (design system)      | Destino (novo projeto)         |
|-----------------------------|-------------------------------|
| `tokens/globals.css`        | `src/app/globals.css`         |
| `components/ui/`            | `src/components/ui/`          |
| `lib/utils.ts`              | `src/lib/utils.ts`            |
| `assets/lyx-logo.svg`       | `public/lyx-logo.svg`         |
| `assets/lyx-logo.png`       | `public/lyx-logo.png`         |

#### 4. Atualizar `src/app/layout.tsx`

Substituir o conteúdo por:

```tsx
import type { Metadata } from "next"
import { Inter, Geist_Mono } from "next/font/google"
import "./globals.css"

const inter = Inter({
  variable: "--font-inter",
  subsets: ["latin"],
})

const geistMono = Geist_Mono({
  variable: "--font-geist-mono",
  subsets: ["latin"],
})

export const metadata: Metadata = {
  title: "Nome do Projeto",
  description: "Descrição do projeto",
}

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="pt-BR" className={`${inter.variable} ${geistMono.variable}`}>
      <body className="antialiased bg-background text-foreground">
        {children}
      </body>
    </html>
  )
}
```

#### 5. (Opcional) Adicionar página de documentação

```bash
# Copiar a página de docs para visualizar no projeto
cp docs/design-system.tsx src/app/design-system/page.tsx
```

Acesse `/design-system` no browser para ver todos os tokens e componentes.

---

## Tokens principais

### Cores (OKLCH)

| Token               | Valor                  | Uso                          |
|---------------------|------------------------|------------------------------|
| `--primary`         | `oklch(0 0 0)`         | Ação principal, botão, ativo |
| `--background`      | `oklch(0.99 0 0)`      | Fundo da página              |
| `--foreground`      | `oklch(0 0 0)`         | Texto principal              |
| `--muted-foreground`| `oklch(0.44 0 0)`      | Texto secundário             |
| `--border`          | `oklch(0.92 0 0)`      | Bordas e divisores           |
| `--destructive`     | `oklch(0.63 0.19 23)`  | Erros e ações destrutivas    |

### Charts

| Token        | Valor                      | Cor      |
|--------------|----------------------------|----------|
| `--chart-1`  | `oklch(0.10 0 0)`          | Preto    |
| `--chart-2`  | `oklch(0.55 0.22 264.53)`  | Azul     |
| `--chart-3`  | `oklch(0.72 0 0)`          | Cinza    |
| `--chart-4`  | `oklch(0.92 0 0)`          | Cinza claro |
| `--chart-5`  | `oklch(0.56 0 0)`          | Cinza médio |

### Sidebar

| Token                        | Valor              |
|------------------------------|--------------------|
| `--sidebar`                  | `oklch(0.99 0 0)`  |
| `--sidebar-foreground`       | `oklch(0 0 0)`     |
| `--sidebar-primary`          | `oklch(0.72 0 0)`  |
| `--sidebar-primary-foreground`| `oklch(1.00 0 0)` |
| `--sidebar-accent`           | `oklch(0.94 0 0)`  |
| `--sidebar-border`           | `oklch(0.94 0 0)`  |

### Tipografia

| Variável          | Fonte       | Uso                   |
|-------------------|-------------|-----------------------|
| `--font-inter`    | Inter       | Texto e interface     |
| `--font-geist-mono`| Geist Mono | Dados, números, código|

### Border radius base

```css
--radius: 0.625rem; /* 10px */
```

---

## Componentes disponíveis

| Componente      | Import                              | Descrição                        |
|-----------------|-------------------------------------|----------------------------------|
| `Button`        | `@/components/ui/button`            | 6 variantes, múltiplos tamanhos  |
| `Badge`         | `@/components/ui/badge`             | Tags e status                    |
| `Card`          | `@/components/ui/card`              | Container com Header/Content/Footer |
| `Table`         | `@/components/ui/table`             | Tabela completa                  |
| `Skeleton`      | `@/components/ui/skeleton`          | Estado de carregamento           |
| `Separator`     | `@/components/ui/separator`         | Divisor horizontal/vertical      |
| `Popover`       | `@/components/ui/popover`           | Flutuante com posicionamento     |
| `ScrollArea`    | `@/components/ui/scroll-area`       | Scroll customizado               |
| `Select`        | `@/components/ui/select`            | Dropdown acessível               |
| `Sidebar`       | `@/components/ui/sidebar`           | Menu lateral composable          |
| `LyxLogo`       | `@/components/ui/lyx-logo`          | Logo SVG inline                  |

### Uso da Sidebar

```tsx
import {
  Sidebar, SidebarTrigger, SidebarHeader,
  SidebarContent, SidebarFooter,
  SidebarGroup, SidebarGroupLabel,
  SidebarMenu, SidebarMenuItem, SidebarMenuButton,
  SidebarSeparator, SidebarUser,
} from "@/components/ui/sidebar"
import { LyxLogo } from "@/components/ui/lyx-logo"
import { useState } from "react"

export function AppSidebar() {
  const [collapsed, setCollapsed] = useState(false)

  return (
    <Sidebar collapsed={collapsed}>
      <SidebarHeader className="relative flex-col items-center pt-5 pb-3">
        <div className="flex flex-col items-center gap-1">
          <img src="/lyx-logo.png" alt="Lyx" style={{ width: collapsed ? 32 : 44 }} className="object-contain" />
          {!collapsed && <span className="text-[11px] font-semibold tracking-wider">Dashboard</span>}
        </div>
        <SidebarTrigger
          collapsed={collapsed}
          onToggle={() => setCollapsed(v => !v)}
          className="absolute top-3 right-1"
        />
      </SidebarHeader>

      <SidebarContent>
        <SidebarGroup>
          <SidebarMenu>
            <SidebarMenuItem>
              <SidebarMenuButton isActive icon={<IconeDashboard />}>Dashboard</SidebarMenuButton>
            </SidebarMenuItem>
          </SidebarMenu>
        </SidebarGroup>
      </SidebarContent>

      <SidebarFooter>
        <SidebarUser name="Nome Usuário" email="email@lyx.com.br" />
      </SidebarFooter>
    </Sidebar>
  )
}
```

---

## Decisões de design

- **OKLCH** no lugar de hex/hsl — uniformidade perceptual, suporte a telas P3
- **Tailwind v4** com `@theme inline` — sem `tailwind.config.js`, tokens direto no CSS
- **Inter** como fonte principal — legibilidade em dashboards e tabelas
- **Radix UI** como base headless — acessibilidade garantida nos primitivos
- **CVA** para variantes — type-safe, sem if/else em className
- **Recharts** para gráficos — integração simples com React, responsivo via `ResponsiveContainer`

---



