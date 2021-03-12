source("helpers.R")
counties <- readRDS("data/counties.rds")
library(maps)
library(mapproj)

# User interface ----
ui <- fluidPage(
  titlePanel("censusVis"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Create demographic maps with 
        information from the 2010 US Census."),
      
      selectInput("var", 
                  label = "Choose a variable to display",
                  choices = c("Percent White", "Percent Black",
                              "Percent Hispanic", "Percent Asian"),
                  selected = "Percent White"),
      
      sliderInput("range", 
                  label = "Range of interest:",
                  min = 0, max = 100, value = c(0, 100))
    ),
    
    mainPanel(plotOutput("map"))
  )
)

# Server logic ----
server <- function(input, output) {
  output$map <- renderPlot({
    inn <- switch(input$var,
                   "Percent White" = list(counties$white, 
                                          "darkgreen", 
                                          "% White"),
                   "Percent Black" = list(counties$black, 
                                          "black", 
                                          "% Black"),
                   "Percent Hispanic" = list(counties$hispanic, 
                                             "darkorange", 
                                             "% Hispanic"),
                   "Percent Asian" = list(counties$asian, 
                                          "darkviolet", 
                                          "% Asian"))
    
    inn$min <- input$range[1]
    inn$max <- input$range[2]
    
    do.call(percent_map, inn)
  })
}

# Run app ----
shinyApp(ui, server)
