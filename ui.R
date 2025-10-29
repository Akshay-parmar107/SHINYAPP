# ui.R
library(shiny)

shinyUI(fluidPage(
  titlePanel("Iris Species Predictor"),
  
  sidebarLayout(
    sidebarPanel(
      h4("Enter Flower Measurements:"),
      sliderInput("sepal_length", "Sepal Length (cm):",
                  min = 4.0, max = 8.0, value = 5.8, step = 0.1),
      sliderInput("sepal_width", "Sepal Width (cm):",
                  min = 2.0, max = 4.5, value = 3.0, step = 0.1),
      sliderInput("petal_length", "Petal Length (cm):",
                  min = 1.0, max = 7.0, value = 4.0, step = 0.1),
      sliderInput("petal_width", "Petal Width (cm):",
                  min = 0.1, max = 2.5, value = 1.2, step = 0.1),
      br(),
      actionButton("predict", "Predict Species", class = "btn-primary")
    ),
    
    mainPanel(
      h3("Prediction Results:"),
      verbatimTextOutput("prediction"),
      br(),
      plotOutput("scatter_plot"),
      br(),
      h4("How to use this app:"),
      p("1. Adjust the sliders to match your flower measurements"),
      p("2. Click the 'Predict Species' button"),
      p("3. View the predicted species and see where your flower falls on the plot"),
      p("The model is trained on the classic Iris dataset using Random Forest.")
    )
  )
))