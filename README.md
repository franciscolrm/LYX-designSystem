# Lyx Design System

Padrão de design para todos os projetos de dashboard e BI da Lyx Incorporadora.

---

## Estrutura do repositório

```
lyx-design-system/
├── tokens/
│   └── globals.css          # Tokens CSS (cores, fontes, radius)
├── components/
│   └── ui/
│       ├── button.tsx
│       ├── badge.tsx
│       ├── card.tsx
│       ├── table.tsx
│       ├── skeleton.tsx
│       ├── separator.tsx
│       ├── popover.tsx
│       ├── scroll-area.tsx
│       ├── select.tsx
│       ├── sidebar.tsx      # Menu lateral composable
│       └── lyx-logo.tsx     # Logo SVG inline
├── lib/
│   └── utils.ts             # Função cn() para merge de classes
├── assets/
│   ├── lyx-logo.svg
│   └── lyx-logo.png
├── docs/
│   └── design-system.tsx    # Página de documentação visual
├── preview/                 # Projeto Next.js para visualizar o design system
├── apply-design-system.sh   # Script para aplicar em novo projeto
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

## Aplicar em um novo projeto

Documentacao completa do aplicador: [`docs/apply-design-system.md`](docs/apply-design-system.md)

### Opção A — Script automático (recomendado)

**Pré-requisito:** ter criado o projeto com `create-next-app`.

```bash
# 1. Criar o projeto
npx create-next-app@latest meu-projeto --typescript --tailwind --eslint --app --src-dir --import-alias "@/*"

# 2. Rodar o script a partir da pasta do design system
bash apply-design-system.sh ../meu-projeto

# 3. Iniciar
cd meu-projeto && npm run dev
```

O script faz tudo automaticamente: instala dependências, copia arquivos e ajusta o `layout.tsx`.

---

### Opção B — Passo a passo manual

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



