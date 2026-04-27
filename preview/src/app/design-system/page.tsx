"use client"

import { useState, useEffect } from "react"
import { Button } from "@/components/ui/button"
import {
  Sidebar, SidebarTrigger, SidebarHeader, SidebarContent, SidebarFooter,
  SidebarGroup, SidebarGroupLabel, SidebarMenu, SidebarMenuItem,
  SidebarMenuButton, SidebarSeparator, SidebarUser,
} from "@/components/ui/sidebar"
import { Badge } from "@/components/ui/badge"
import { Card, CardHeader, CardTitle, CardDescription, CardContent, CardFooter } from "@/components/ui/card"
import { Skeleton } from "@/components/ui/skeleton"
import { Separator } from "@/components/ui/separator"
import {
  Table, TableHeader, TableBody, TableHead, TableRow, TableCell, TableFooter
} from "@/components/ui/table"
import {
  BarChart, Bar, LineChart, Line, AreaChart, Area,
  XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, PieChart, Pie, Cell
} from "recharts"
import {
  TrendingUp, TrendingDown, Home, FileText, BarChart2,
  Settings, Download, AlertTriangle, CheckCircle, Info, Bell
} from "lucide-react"

const barData = [
  { mes: "Jan", valor: 42, meta: 50 },
  { mes: "Fev", valor: 58, meta: 50 },
  { mes: "Mar", valor: 35, meta: 50 },
  { mes: "Abr", valor: 72, meta: 60 },
  { mes: "Mai", valor: 61, meta: 60 },
  { mes: "Jun", valor: 88, meta: 70 },
]

const lineData = [
  { mes: "Jan", qrs: 12, distratos: 3 },
  { mes: "Fev", qrs: 19, distratos: 5 },
  { mes: "Mar", qrs: 8, distratos: 2 },
  { mes: "Abr", qrs: 24, distratos: 4 },
  { mes: "Mai", qrs: 17, distratos: 6 },
  { mes: "Jun", qrs: 31, distratos: 3 },
]

const pieData = [
  { name: "Curitiba", value: 63 },
  { name: "Porto Alegre", value: 37 },
]

const tableRows = [
  { unidade: "101-A", empreendimento: "Residencial Aurora", status: "Vendida", valor: "R$ 420.000", data: "15/04/2026" },
  { unidade: "204-B", empreendimento: "Residencial Bela Vista", status: "Reservada", valor: "R$ 380.000", data: "18/04/2026" },
  { unidade: "305-C", empreendimento: "Residencial Canto Verde", status: "Disponível", valor: "R$ 510.000", data: "—" },
  { unidade: "102-A", empreendimento: "Residencial Aurora", status: "Distrato", valor: "R$ 420.000", data: "20/04/2026" },
  { unidade: "401-D", empreendimento: "Residencial Delta", status: "Vendida", valor: "R$ 650.000", data: "22/04/2026" },
]

const statusVariant: Record<string, "default" | "secondary" | "outline" | "destructive"> = {
  Vendida: "default",
  Reservada: "secondary",
  Disponível: "outline",
  Distrato: "destructive",
}

const CHART_COLORS = [
  "var(--color-chart-1)",
  "var(--color-chart-2)",
  "var(--color-chart-3)",
  "var(--color-chart-4)",
  "var(--color-chart-5)",
]

function Section({ title, children }: { title: string; children: React.ReactNode }) {
  return (
    <section className="space-y-4">
      <div>
        <h2 className="text-lg font-semibold text-foreground">{title}</h2>
        <Separator className="mt-2" />
      </div>
      {children}
    </section>
  )
}

function ColorSwatch({ label, cssVar }: { label: string; cssVar: string }) {
  const [value, setValue] = useState("")

  useEffect(() => {
    const v = getComputedStyle(document.documentElement).getPropertyValue(cssVar).trim()
    setValue(v || cssVar)
  }, [cssVar])

  return (
    <div className="flex items-center gap-3">
      <div
        className="h-12 w-12 rounded-lg border shadow-sm flex-shrink-0"
        style={{ background: `var(${cssVar})` }}
      />
      <div className="flex flex-col gap-0.5">
        <span className="text-sm font-medium text-foreground">{label}</span>
        <span className="text-xs text-muted-foreground font-mono">{value}</span>
      </div>
    </div>
  )
}

export default function DesignSystemPage() {
  const [sidebarCollapsed, setSidebarCollapsed] = useState(false)

  return (
    <div className="min-h-screen bg-background px-8 py-10 space-y-14">

      {/* Header */}
      <div className="space-y-1">
        <h1 className="text-3xl font-bold text-foreground">Design System</h1>
        <p className="text-muted-foreground text-sm">Tokens, componentes e padrões visuais do Dashboard BI.</p>
      </div>

      {/* ── CORES ── */}
      <Section title="Cores — Tokens">
        <div className="space-y-6">
          <div>
            <p className="text-xs text-muted-foreground mb-3 uppercase tracking-wider font-medium">Primary Theme Colors</p>
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
              <ColorSwatch label="Background" cssVar="--background" />
              <ColorSwatch label="Foreground" cssVar="--foreground" />
              <ColorSwatch label="Primary" cssVar="--primary" />
              <ColorSwatch label="Primary Foreground" cssVar="--primary-foreground" />
            </div>
          </div>
          <div>
            <p className="text-xs text-muted-foreground mb-3 uppercase tracking-wider font-medium">Secondary & Accent Colors</p>
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
              <ColorSwatch label="Secondary" cssVar="--secondary" />
              <ColorSwatch label="Secondary Foreground" cssVar="--secondary-foreground" />
              <ColorSwatch label="Accent" cssVar="--accent" />
              <ColorSwatch label="Accent Foreground" cssVar="--accent-foreground" />
            </div>
          </div>
          <div>
            <p className="text-xs text-muted-foreground mb-3 uppercase tracking-wider font-medium">Neutros & Estado</p>
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
              <ColorSwatch label="Muted" cssVar="--muted" />
              <ColorSwatch label="Muted Foreground" cssVar="--muted-foreground" />
              <ColorSwatch label="Border" cssVar="--border" />
              <ColorSwatch label="Input" cssVar="--input" />
              <ColorSwatch label="Ring" cssVar="--ring" />
              <ColorSwatch label="Destructive" cssVar="--destructive" />
            </div>
          </div>
          <div>
            <p className="text-xs text-muted-foreground mb-3 uppercase tracking-wider font-medium">Sidebar</p>
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
              <ColorSwatch label="Sidebar BG" cssVar="--sidebar" />
              <ColorSwatch label="Sidebar FG" cssVar="--sidebar-foreground" />
              <ColorSwatch label="Sidebar Primary" cssVar="--sidebar-primary" />
              <ColorSwatch label="Sidebar Accent" cssVar="--sidebar-accent" />
              <ColorSwatch label="Sidebar Border" cssVar="--sidebar-border" />
            </div>
          </div>
          <div>
            <p className="text-xs text-muted-foreground mb-3 uppercase tracking-wider font-medium">Charts</p>
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
              <ColorSwatch label="Chart 1" cssVar="--chart-1" />
              <ColorSwatch label="Chart 2" cssVar="--chart-2" />
              <ColorSwatch label="Chart 3" cssVar="--chart-3" />
              <ColorSwatch label="Chart 4" cssVar="--chart-4" />
              <ColorSwatch label="Chart 5" cssVar="--chart-5" />
            </div>
          </div>
        </div>
      </Section>

      {/* ── TIPOGRAFIA ── */}
      <Section title="Tipografia">
        <Card>
          <CardContent className="pt-6 space-y-4">
            <div className="flex items-baseline gap-4">
              <span className="text-xs text-muted-foreground w-16">3xl</span>
              <span className="text-3xl font-bold">Dashboard Secretaria</span>
            </div>
            <div className="flex items-baseline gap-4">
              <span className="text-xs text-muted-foreground w-16">2xl</span>
              <span className="text-2xl font-semibold">Total de Repasses CEF</span>
            </div>
            <div className="flex items-baseline gap-4">
              <span className="text-xs text-muted-foreground w-16">xl</span>
              <span className="text-xl font-semibold">Unidades Disponíveis</span>
            </div>
            <div className="flex items-baseline gap-4">
              <span className="text-xs text-muted-foreground w-16">lg</span>
              <span className="text-lg font-medium">Resumo Mensal de QRs</span>
            </div>
            <div className="flex items-baseline gap-4">
              <span className="text-xs text-muted-foreground w-16">base</span>
              <span className="text-base">Análise de estoque por empreendimento e praça comercial.</span>
            </div>
            <div className="flex items-baseline gap-4">
              <span className="text-xs text-muted-foreground w-16">sm</span>
              <span className="text-sm text-muted-foreground">Dados atualizados em 23/04/2026 às 09:15</span>
            </div>
            <div className="flex items-baseline gap-4">
              <span className="text-xs text-muted-foreground w-16">xs mono</span>
              <span className="text-xs font-mono text-muted-foreground">R$ 1.234.567,89 · 42 unidades · 6 praças</span>
            </div>
          </CardContent>
        </Card>
      </Section>

      {/* ── BOTÕES ── */}
      <Section title="Botões">
        <Card>
          <CardContent className="pt-6 space-y-6">
            <div>
              <p className="text-xs text-muted-foreground mb-3 uppercase tracking-wider font-medium">Variantes</p>
              <div className="flex flex-wrap gap-3">
                <Button variant="default">Confirmar</Button>
                <Button variant="secondary">Secundário</Button>
                <Button variant="outline">Outline</Button>
                <Button variant="ghost">Ghost</Button>
                <Button variant="destructive">Excluir</Button>
                <Button variant="link">Ver detalhes</Button>
              </div>
            </div>
            <div>
              <p className="text-xs text-muted-foreground mb-3 uppercase tracking-wider font-medium">Tamanhos</p>
              <div className="flex flex-wrap items-center gap-3">
                <Button size="lg"><Download />Exportar Excel</Button>
                <Button size="default"><Download />Exportar</Button>
                <Button size="sm"><Download />Exportar</Button>
                <Button size="xs"><Download />Exportar</Button>
              </div>
            </div>
            <div>
              <p className="text-xs text-muted-foreground mb-3 uppercase tracking-wider font-medium">Ícones</p>
              <div className="flex flex-wrap gap-3">
                <Button size="icon"><Settings /></Button>
                <Button size="icon" variant="outline"><Bell /></Button>
                <Button size="icon-sm" variant="ghost"><Home /></Button>
                <Button size="icon-xs" variant="secondary"><Info /></Button>
              </div>
            </div>
            <div>
              <p className="text-xs text-muted-foreground mb-3 uppercase tracking-wider font-medium">Estados</p>
              <div className="flex flex-wrap gap-3">
                <Button disabled>Desabilitado</Button>
                <Button variant="outline" disabled>Desabilitado</Button>
              </div>
            </div>
          </CardContent>
        </Card>
      </Section>

      {/* ── BADGES ── */}
      <Section title="Badges">
        <Card>
          <CardContent className="pt-6">
            <div className="flex flex-wrap gap-3">
              <Badge variant="default">Vendida</Badge>
              <Badge variant="secondary">Reservada</Badge>
              <Badge variant="outline">Disponível</Badge>
              <Badge variant="destructive">Distrato</Badge>
              <Badge variant="default"><CheckCircle />Aprovado</Badge>
              <Badge variant="destructive"><AlertTriangle />Cancelado</Badge>
              <Badge variant="secondary"><TrendingUp />+12%</Badge>
              <Badge variant="outline"><TrendingDown />-5%</Badge>
            </div>
          </CardContent>
        </Card>
      </Section>

      {/* ── CARDS KPI ── */}
      <Section title="Cards — KPI">
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
          <Card>
            <CardHeader>
              <CardTitle className="text-sm font-medium text-muted-foreground">Total Repasses CEF</CardTitle>
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">R$ 12,4M</div>
              <div className="flex items-center gap-1 mt-1">
                <Badge variant="secondary" className="text-xs"><TrendingUp />+8,2%</Badge>
                <span className="text-xs text-muted-foreground">vs mês anterior</span>
              </div>
            </CardContent>
          </Card>
          <Card>
            <CardHeader>
              <CardTitle className="text-sm font-medium text-muted-foreground">QRs no Mês</CardTitle>
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">31</div>
              <div className="flex items-center gap-1 mt-1">
                <Badge variant="destructive" className="text-xs"><TrendingDown />-3</Badge>
                <span className="text-xs text-muted-foreground">vs mês anterior</span>
              </div>
            </CardContent>
          </Card>
          <Card>
            <CardHeader>
              <CardTitle className="text-sm font-medium text-muted-foreground">Estoque Disponível</CardTitle>
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">142</div>
              <span className="text-xs text-muted-foreground">unidades em 4 praças</span>
            </CardContent>
          </Card>
          <Card>
            <CardHeader>
              <CardTitle className="text-sm font-medium text-muted-foreground">Minutas Pendentes</CardTitle>
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">18</div>
              <Badge variant="outline" className="mt-1 text-xs">Curitiba-PR</Badge>
            </CardContent>
          </Card>
        </div>
      </Section>

      {/* ── TABELA ── */}
      <Section title="Tabela">
        <Card>
          <CardHeader>
            <CardTitle>Últimas Transações</CardTitle>
            <CardDescription>Movimentações recentes do período selecionado.</CardDescription>
          </CardHeader>
          <CardContent>
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Unidade</TableHead>
                  <TableHead>Empreendimento</TableHead>
                  <TableHead>Status</TableHead>
                  <TableHead className="text-right">Valor</TableHead>
                  <TableHead className="text-right">Data</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {tableRows.map((row) => (
                  <TableRow key={row.unidade}>
                    <TableCell className="font-mono font-medium">{row.unidade}</TableCell>
                    <TableCell>{row.empreendimento}</TableCell>
                    <TableCell>
                      <Badge variant={statusVariant[row.status]}>{row.status}</Badge>
                    </TableCell>
                    <TableCell className="text-right font-mono">{row.valor}</TableCell>
                    <TableCell className="text-right text-muted-foreground">{row.data}</TableCell>
                  </TableRow>
                ))}
              </TableBody>
              <TableFooter>
                <TableRow>
                  <TableCell colSpan={3}>Total</TableCell>
                  <TableCell className="text-right font-mono">R$ 1.980.000</TableCell>
                  <TableCell />
                </TableRow>
              </TableFooter>
            </Table>
          </CardContent>
        </Card>
      </Section>

      {/* ── GRÁFICOS ── */}
      <Section title="Gráficos">
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-4">
          {/* Bar */}
          <Card>
            <CardHeader>
              <CardTitle>Repasses por Mês</CardTitle>
              <CardDescription>Comparativo valor realizado vs meta.</CardDescription>
            </CardHeader>
            <CardContent>
              <ResponsiveContainer width="100%" height={220}>
                <BarChart data={barData} barSize={24}>
                  <CartesianGrid strokeDasharray="3 3" stroke="var(--color-border)" />
                  <XAxis dataKey="mes" tick={{ fontSize: 12, fill: "var(--color-muted-foreground)" }} axisLine={false} tickLine={false} />
                  <YAxis tick={{ fontSize: 12, fill: "var(--color-muted-foreground)" }} axisLine={false} tickLine={false} />
                  <Tooltip
                    contentStyle={{ background: "var(--color-card)", border: "1px solid var(--color-border)", borderRadius: 8, fontSize: 12 }}
                  />
                  <Bar dataKey="valor" fill="var(--color-chart-2)" radius={[4, 4, 0, 0]} name="Realizado" />
                  <Bar dataKey="meta" fill="var(--color-chart-1)" radius={[4, 4, 0, 0]} name="Meta" />
                </BarChart>
              </ResponsiveContainer>
            </CardContent>
          </Card>

          {/* Line */}
          <Card>
            <CardHeader>
              <CardTitle>QRs vs Distratos</CardTitle>
              <CardDescription>Evolução mensal de qualificações e cancelamentos.</CardDescription>
            </CardHeader>
            <CardContent>
              <ResponsiveContainer width="100%" height={220}>
                <LineChart data={lineData}>
                  <CartesianGrid strokeDasharray="3 3" stroke="var(--color-border)" />
                  <XAxis dataKey="mes" tick={{ fontSize: 12, fill: "var(--color-muted-foreground)" }} axisLine={false} tickLine={false} />
                  <YAxis tick={{ fontSize: 12, fill: "var(--color-muted-foreground)" }} axisLine={false} tickLine={false} />
                  <Tooltip
                    contentStyle={{ background: "var(--color-card)", border: "1px solid var(--color-border)", borderRadius: 8, fontSize: 12 }}
                  />
                  <Line type="monotone" dataKey="qrs" stroke="var(--color-chart-1)" strokeWidth={2} dot={{ r: 3 }} name="QRs" />
                  <Line type="monotone" dataKey="distratos" stroke="var(--color-destructive)" strokeWidth={2} dot={{ r: 3 }} name="Distratos" />
                </LineChart>
              </ResponsiveContainer>
            </CardContent>
          </Card>

          {/* Area */}
          <Card>
            <CardHeader>
              <CardTitle>Volume Acumulado</CardTitle>
              <CardDescription>Área — repasses acumulados no semestre.</CardDescription>
            </CardHeader>
            <CardContent>
              <ResponsiveContainer width="100%" height={220}>
                <AreaChart data={barData}>
                  <defs>
                    <linearGradient id="grad1" x1="0" y1="0" x2="0" y2="1">
                      <stop offset="5%" stopColor="var(--color-chart-1)" stopOpacity={0.3} />
                      <stop offset="95%" stopColor="var(--color-chart-1)" stopOpacity={0} />
                    </linearGradient>
                  </defs>
                  <CartesianGrid strokeDasharray="3 3" stroke="var(--color-border)" />
                  <XAxis dataKey="mes" tick={{ fontSize: 12, fill: "var(--color-muted-foreground)" }} axisLine={false} tickLine={false} />
                  <YAxis tick={{ fontSize: 12, fill: "var(--color-muted-foreground)" }} axisLine={false} tickLine={false} />
                  <Tooltip
                    contentStyle={{ background: "var(--color-card)", border: "1px solid var(--color-border)", borderRadius: 8, fontSize: 12 }}
                  />
                  <Area type="monotone" dataKey="valor" stroke="var(--color-chart-1)" fill="url(#grad1)" strokeWidth={2} name="Repasses" />
                </AreaChart>
              </ResponsiveContainer>
            </CardContent>
          </Card>

          {/* Pie */}
          <Card>
            <CardHeader>
              <CardTitle>Distribuição por Praça</CardTitle>
              <CardDescription>Participação percentual de cada praça no total.</CardDescription>
            </CardHeader>
            <CardContent className="flex items-center gap-8">
              <ResponsiveContainer width={180} height={180}>
                <PieChart>
                  <Pie data={pieData} cx="50%" cy="50%" innerRadius={50} outerRadius={80} dataKey="value" paddingAngle={3}>
                    {pieData.map((_, i) => (
                      <Cell key={i} fill={CHART_COLORS[i % CHART_COLORS.length]} />
                    ))}
                  </Pie>
                  <Tooltip
                    contentStyle={{ background: "var(--color-card)", border: "1px solid var(--color-border)", borderRadius: 8, fontSize: 12 }}
                  />
                </PieChart>
              </ResponsiveContainer>
              <div className="space-y-3">
                {pieData.map((item, i) => (
                  <div key={item.name} className="flex items-center gap-2">
                    <div className="h-3 w-3 rounded-full" style={{ background: CHART_COLORS[i] }} />
                    <span className="text-sm font-medium">{item.name}</span>
                    <span className="text-sm text-muted-foreground">{item.value}%</span>
                  </div>
                ))}
              </div>
            </CardContent>
          </Card>
        </div>
      </Section>

      {/* ── SKELETONS ── */}
      <Section title="Skeleton / Loading">
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-4">
          <Card>
            <CardHeader>
              <Skeleton className="h-5 w-40" />
              <Skeleton className="h-4 w-64" />
            </CardHeader>
            <CardContent className="space-y-3">
              <Skeleton className="h-8 w-32" />
              <Skeleton className="h-4 w-full" />
              <Skeleton className="h-4 w-3/4" />
              <Skeleton className="h-4 w-1/2" />
            </CardContent>
          </Card>
          <Card>
            <CardContent className="pt-6 space-y-3">
              {[...Array(5)].map((_, i) => (
                <div key={i} className="flex items-center gap-3">
                  <Skeleton className="h-4 w-16" />
                  <Skeleton className="h-4 flex-1" />
                  <Skeleton className="h-6 w-20 rounded-full" />
                  <Skeleton className="h-4 w-24" />
                </div>
              ))}
            </CardContent>
          </Card>
        </div>
      </Section>

      {/* ── BORDER RADIUS ── */}
      <Section title="Border Radius">
        <Card>
          <CardContent className="pt-6">
            <div className="flex flex-wrap items-end gap-6">
              {[
                { label: "sm", cls: "rounded-sm" },
                { label: "md", cls: "rounded-md" },
                { label: "lg", cls: "rounded-lg" },
                { label: "xl", cls: "rounded-xl" },
                { label: "2xl", cls: "rounded-2xl" },
                { label: "3xl", cls: "rounded-3xl" },
                { label: "full", cls: "rounded-full" },
              ].map(({ label, cls }) => (
                <div key={label} className="flex flex-col items-center gap-2">
                  <div className={`h-12 w-12 bg-primary ${cls}`} />
                  <span className="text-xs text-muted-foreground">{label}</span>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>
      </Section>

      {/* ── SIDEBAR PREVIEW ── */}
      <Section title="Sidebar — Preview">
        <div className="relative flex rounded-xl overflow-hidden border shadow-sm" style={{ height: 400 }}>
          {/* Trigger na linha divisória, anima junto com a sidebar */}
          <div
            className="absolute z-20"
            style={{
              left: sidebarCollapsed ? 64 : 240,
              top: 38,
              transition: "left 300ms cubic-bezier(0.4,0,0.2,1)",
              transform: "translate(-50%, -50%)",
            }}
          >
            <SidebarTrigger
              collapsed={sidebarCollapsed}
              onToggle={() => setSidebarCollapsed(v => !v)}
            />
          </div>

          <Sidebar collapsed={sidebarCollapsed}>
            <SidebarHeader className="flex-col items-center pt-5 pb-3">
              <div className="flex flex-col items-center gap-1">
                <img
                  src="/lyx-logo.png"
                  alt="Lyx"
                  className="object-contain flex-shrink-0"
                  style={{ width: sidebarCollapsed ? 32 : 44, transition: "width 300ms cubic-bezier(0.4,0,0.2,1)" }}
                />
                <span className={`text-[11px] font-semibold tracking-wider text-sidebar-foreground whitespace-nowrap transition-all duration-200 ${sidebarCollapsed ? "opacity-0 h-0 overflow-hidden" : "opacity-100"}`}>
                  Dashboard
                </span>
              </div>
            </SidebarHeader>

            <SidebarContent>
              <SidebarGroup>
                <SidebarMenu>
                  <SidebarMenuItem>
                    <SidebarMenuButton isActive icon={<BarChart2 size={16} />}>Dashboard</SidebarMenuButton>
                  </SidebarMenuItem>
                  <SidebarMenuItem>
                    <SidebarMenuButton icon={<FileText size={16} />}>Minutas</SidebarMenuButton>
                  </SidebarMenuItem>
                  <SidebarMenuItem>
                    <SidebarMenuButton icon={<Home size={16} />}>Estoques</SidebarMenuButton>
                  </SidebarMenuItem>
                  <SidebarMenuItem>
                    <SidebarMenuButton icon={<Download size={16} />}>Exportar Dados</SidebarMenuButton>
                  </SidebarMenuItem>
                </SidebarMenu>
              </SidebarGroup>

              <SidebarSeparator />

              <SidebarGroup>
                <SidebarGroupLabel>Sistema</SidebarGroupLabel>
                <SidebarMenu>
                  <SidebarMenuItem>
                    <SidebarMenuButton icon={<Bell size={16} />}>Notificações</SidebarMenuButton>
                  </SidebarMenuItem>
                  <SidebarMenuItem>
                    <SidebarMenuButton icon={<Settings size={16} />}>Configurações</SidebarMenuButton>
                  </SidebarMenuItem>
                </SidebarMenu>
              </SidebarGroup>
            </SidebarContent>

            <SidebarFooter>
              <SidebarUser name="Francisco Moreira" email="tecnologia@lyx.com.br" />
            </SidebarFooter>
          </Sidebar>

          <div className="flex-1 bg-background p-6 flex flex-col justify-center items-center gap-2">
            <span className="text-muted-foreground text-sm">Área de conteúdo</span>
            <span className="text-xs text-muted-foreground">bg-background</span>
          </div>
        </div>
      </Section>

      <div className="pb-10 text-center text-xs text-muted-foreground">
        Design System · Dashboard Secretaria · Lyx Incorporadora
      </div>
    </div>
  )
}
