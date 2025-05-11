library(shiny)

# Define UI
ui <- fluidPage(
  titlePanel("Dynamic Iris Plot"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("xvar", "X-axis:", choices = names(iris)[1:4], selected = "Sepal.Length"),
      selectInput("yvar", "Y-axis:", choices = names(iris)[1:4], selected = "Sepal.Width"),
      selectInput("species", "Filter by Species:",
                  choices = c("All", unique(as.character(iris$Species))),
                  selected = "All")
    ),
    
    mainPanel(
      plotOutput("irisPlot")
    )
  )
)

# Define Server
server <- function(input, output) {
  
  # Reactive data based on species filter
  filteredData <- reactive({
    if (input$species == "All") {
      iris
    } else {
      subset(iris, Species == input$species)
    }
  })
  
  # Render Plot
  output$irisPlot <- renderPlot({
    data <- filteredData()
    plot(data[[input$xvar]], data[[input$yvar]],
         xlab = input$xvar,
         ylab = input$yvar,
         col = data$Species,
         pch = 19,
         main = paste(input$yvar, "vs", input$xvar))
  })
}

# Run the app
shinyApp(ui = ui, server = server)
