# server.R
library(shiny)
library(randomForest)
library(ggplot2)

# Load and prepare the data
data(iris)

# Train the model once when the app starts
set.seed(123)
iris_model <- randomForest(Species ~ ., data = iris, ntree = 100)

shinyServer(function(input, output) {
  
  # Create reactive values
  values <- reactiveValues(
    prediction = NULL,
    probabilities = NULL
  )
  
  # When predict button is clicked
  observeEvent(input$predict, {
    # Create new data frame with user inputs
    new_flower <- data.frame(
      Sepal.Length = input$sepal_length,
      Sepal.Width = input$sepal_width,
      Petal.Length = input$petal_length,
      Petal.Width = input$petal_width
    )
    
    # Make prediction
    pred <- predict(iris_model, newdata = new_flower, type = "response")
    prob <- predict(iris_model, newdata = new_flower, type = "prob")
    
    values$prediction <- pred
    values$probabilities <- prob
  })
  
  # Output prediction text
  output$prediction <- renderText({
    if (is.null(values$prediction)) {
      "Please click 'Predict Species' to see results"
    } else {
      species <- as.character(values$prediction)
      probs <- round(values$probabilities[1, species] * 100, 1)
      paste("Predicted Species: ", species, "\n",
            "Confidence: ", probs, "%", "\n",
            "\nProbability breakdown:\n",
            "setosa: ", round(values$probabilities[1, "setosa"] * 100, 1), "%\n",
            "versicolor: ", round(values$probabilities[1, "versicolor"] * 100, 1), "%\n",
            "virginica: ", round(values$probabilities[1, "virginica"] * 100, 1), "%")
    }
  })
  
  # Output scatter plot
  output$scatter_plot <- renderPlot({
    # Create base plot
    p <- ggplot(iris, aes(x = Petal.Length, y = Petal.Width, color = Species)) +
      geom_point(alpha = 0.7, size = 3) +
      theme_minimal() +
      labs(title = "Iris Species by Petal Measurements",
           x = "Petal Length (cm)",
           y = "Petal Width (cm)")
    
    # Add user's point if prediction has been made
    if (!is.null(values$prediction)) {
      p <- p + 
        geom_point(aes(x = input$petal_length, y = input$petal_width), 
                   color = "red", size = 5, shape = 8, stroke = 2) +
        annotate("text", x = input$petal_length, y = input$petal_width + 0.2,
                 label = "Your Flower", color = "red", size = 4)
    }
    
    p
  })
})