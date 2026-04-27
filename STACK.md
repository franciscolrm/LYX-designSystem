# Stack — Lyx Design System

## Framework
| Tecnologia | Versão | Papel |
|---|---|---|
| Next.js | 16.x | Framework React (App Router) |
| React | 19.x | UI runtime |
| TypeScript | 5.x | Tipagem estática |

## Estilização
| Tecnologia | Versão | Papel |
|---|---|---|
| Tailwind CSS | 4.x | Utility-first CSS |
| @tailwindcss/postcss | 4.x | Plugin PostCSS p/ Tailwind v4 |
| tw-animate-css | latest | Animações via Tailwind |
| tailwind-merge | 3.x | Merge seguro de classes |
| clsx | 2.x | Composição condicional de classes |
| class-variance-authority | 0.7.x | Variantes de componentes (CVA) |

## Componentes
| Tecnologia | Versão | Papel |
|---|---|---|
| Radix UI | 1.4.x | Primitivos acessíveis (headless) |
| Lucide React | latest | Ícones SVG |

## Visualização de Dados
| Tecnologia | Versão | Papel |
|---|---|---|
| Recharts | 3.x | Gráficos (Bar, Line, Area, Pie) |

## Fontes
| Fonte | Tipo | Variável CSS |
|---|---|---|
| Geist Sans | Sans-serif principal | `--font-geist-sans` |
| Geist Mono | Monospace (dados/números) | `--font-geist-mono` |
| Origem | `next/font/google` | Otimizado automaticamente |

## Sistema de Cores
- Espaço de cor: **OKLCH** (perceptualmente uniforme, suporte a P3)
- Tokens definidos em `tokens/globals.css` via `@theme inline` (Tailwind v4)
- Suporte nativo a **light mode** e **dark mode**
- Sem `tailwind.config.js` — configuração inline no CSS

## Banco de Dados (projetos BI)
| Tecnologia | Versão | Papel |
|---|---|---|
| Prisma | 6.x | ORM + migrations |
| MySQL | 8.x | Banco relacional |

## Deploy
| Tecnologia | Papel |
|---|---|
| Docker + Dockerfile | Containerização |
| docker-compose.yml | Orquestração local |
| Dokploy | Deploy via container (produção) |
| Next.js `output: standalone` | Build otimizado para container |

## Ferramentas de Desenvolvimento
| Tecnologia | Papel |
|---|---|
| ESLint 9 | Linting |
| PostCSS | Processamento CSS |
