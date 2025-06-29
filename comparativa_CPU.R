# ── Librerías necesarias ─────────────────────
library(shiny)
library(shinydashboard)
library(ggplot2)
library(dplyr)

# ── Cargar dataset ───────────────────────────
data <- read.csv("comparativa_procesadores.csv")

# ── UI ───────────────────────────────────────
ui <- dashboardPage(
  dashboardHeader(title = "Comparativa de CPUs"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Rendimiento", tabName = "rendimiento", icon = icon("microchip")),
      menuItem("Ventas", tabName = "ventas", icon = icon("chart-bar")),
      menuItem("Preferencias", tabName = "preferencias", icon = icon("heart")),
      menuItem("Presentación", tabName = "story", icon = icon("info-circle"))
    )
  ),
  
  dashboardBody(
    tabItems(
      
      # ── Pestaña: Rendimiento ───────────────
      tabItem(tabName = "rendimiento",
              fluidRow(
                box(title = "Evolución del rendimiento promedio", width = 12, status = "primary", solidHeader = TRUE,
                    plotOutput("rendimiento_linea"))
              )
      ),
      
      # ── Pestaña: Ventas ────────────────────
      tabItem(tabName = "ventas",
              fluidRow(
                box(title = "Ventas por año y marca", width = 12, status = "success", solidHeader = TRUE,
                    plotOutput("ventas_barra"))
              )
      ),
      
      # ── Pestaña: Preferencia ───────────────
      tabItem(tabName = "preferencias",
              fluidRow(
                box(title = "Preferencia del público a lo largo del tiempo", width = 12, status = "danger", solidHeader = TRUE,
                    plotOutput("preferencia_area"))
              )
      ),
      
      # ── Pestaña: Storytelling ──────────────
      tabItem(tabName = "story",
              fluidRow(
                box(title = "¿Cómo cambió la pelea entre procesadores?", width = 12, status = "warning", solidHeader = TRUE,
                    p("Durante años, Intel fue el rey indiscutido del mercado de procesadores. 
              Sin embargo, en la última década, AMD empezó a recortar distancia… 
              y no solo en rendimiento, sino también en ventas y en la percepción del público."),
                    
                    p("Este dashboard busca mostrar esa historia: cómo una marca fue perdiendo terreno 
              y otra fue ganando la confianza de la gente, año tras año."),
                    
                    p("Con estos gráficos se puede explorar la evolución desde 2015 hasta 2024, 
              analizando rendimiento, ventas y preferencia del público. 
              El objetivo es que cualquiera pueda entender lo que pasó en el mercado en los últimos años, 
              de forma visual y clara.")
                )
              )
      )
    )
  )
)

# ── SERVER ──────────────────────────────────
server <- function(input, output) {
  
  output$rendimiento_linea <- renderPlot({
    ggplot(data, aes(x = Año, y = Rendimiento_Promedio, color = Marca)) +
      geom_line(size = 1.2) +
      labs(x = "Año", y = "Rendimiento promedio", color = "Marca") +
      theme_minimal()
  })
  
  output$ventas_barra <- renderPlot({
    ggplot(data, aes(x = factor(Año), y = Ventas_Millones, fill = Marca)) +
      geom_bar(stat = "identity", position = "dodge") +
      labs(x = "Año", y = "Ventas (millones)", fill = "Marca") +
      theme_classic()
  })
  
  output$preferencia_area <- renderPlot({
    ggplot(data, aes(x = Año, y = Preferencia_Publico, fill = Marca)) +
      geom_area(alpha = 0.6, position = "stack") +
      labs(x = "Año", y = "Preferencia del público (%)", fill = "Marca") +
      theme_light()
  })
}

# ── Correr la App ───────────────────────────
shinyApp(ui, server)

