#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

## Getting data frame of interest (app code below)


#########################################################################


library(shiny)
library(DT)
library(shinydashboard)

data <- read.csv("data.csv") ## .csv file needs to be in same directory as the app file 

# Define UI for application that draws a histogram
ui <- dashboardPage(

    # Application title
    dashboardHeader(title = "Diabetes Data"),
    dashboardSidebar(),
    dashboardBody(
        fluidRow(column(width = 6,
        box(title = "What data would you like to see?", width = NULL, checkboxGroupInput("variable", "Variables:",
                           c("Diabetes" = "Diabetes",
                             "Height" = "Height_In",
                             "Weight" = "Weight_lbs",
                             "BMI" = "BMI",
                             "Alcohol Consumption" = "Alcohol_Consum",
                             "Sick Days Taken" = "Sick_Days_General",
                             "Nightly Sleep Hours" = "Hours_Sleep_Night",
                             "Joint Pain" = "Joint_Pain"))
            ),
        box(title = "Diabetes Tidy Data (Scrollbar below)", width = NULL, div(style = 'overflow-x:scroll', dataTableOutput("data")))
        
             ), 
        column(width = 6, 
               box(title = "Choose a Histogram:", width = NULL, selectInput("hist", "Histograms", choices = c("BMI" = "BMI",
                                                                                                     "Alcohol Consumption" = "Alcohol_Consum",
                                                                                                     "Sick Days Taken" = "Sick_Days_General",
                                                                                                     "Nightly Sleep Hours" = "Hours_Sleep_Night"))),
                 box("Distributions", width = NULL, plotOutput("histogram"))
               )
         )
    )
)

    
    server <- function(input, output, session) {
        output$data <- renderDataTable({
            data[, c(input$variable), drop = FALSE]
        })
        
        output$histogram <- renderPlot(
            ggplot(data) + geom_histogram(aes(x = data[,input$hist]), binwidth = 1, color = 'black', fill = 'red') + 
                labs(x = "Variable of Interest", y = "Count")
            
        )
    }
    
  
shinyApp(ui = ui, server = server)
