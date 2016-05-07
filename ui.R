#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
###THIs is the NEWEST
library(shiny)
library(stringr)
library(plotly)

# Define UI for application that draws a histogram
shinyUI(fluidPage(theme = "bootstrap.css",
  
     # Application title
     titlePanel("Coursera Developing Data Project - Mariners Viz"),
  
     # Sidebar with a slider input for number of bins 
     sidebarLayout(
    
          # Show a plot of the generated distribution
          mainPanel(
               tabsetPanel(
#                    tabPanel(p(icon("table"), "Explore the Data"),
#                             h4('data', align = "left"),
#                             dataTableOutput(outputId="mytable")
#                    ),
                    tabPanel(p(icon("info"), "About"),
                             helpText("Data courtesy of BaseballSavant.com"),
                             helpText("To use the Heatmap tab, select a player (2016 Mariner Batters) and a ggplot graph will render of that hitter's batted balls colored by exit velocity."),
                             helpText("To use the Hit Type Expectancy tab, select a player (2016 Mariner Batters) and a plotly graph will render of that hitters hits based on exit velocity and launch angle colored by outcome."),
                             helpText("At the bottom of this tab is a Hit Expectacy Predictor.  The model is trained on the 2016 Mariners hitting outcomes.  Input a launch angle and exit velocity and it will predict the outcome."),
                             helpText("A random forest model is used to predict the hit types.  The model takes the launch angle and the hit velocity as features.  Currently its accuracy is only 55%."),
                             hr(),
                             helpText("Future updates to do:"),
                             helpText("Put data in a google sheet"),
                             helpText("Add more teams, make them selectable"),
                             helpText("Render graphs based on date inputs"),
                             helpText("Add more features to improve the model, eventually developing an Expected Batting Average model"),
                             hr(),
                             helpText("Code is located here : "),
                             helpText("Questions, comments, criticism: star9475@hotmail.com")
                             
                    ), # end of "Visualize the Data" tab panel
                    tabPanel(p(icon("line-chart"), "Heatmaps"),
#                             h4('Insert Data table', align = "left"),
#                             hr(),
 #                            fluidRow(column(10, verbatimTextOutput("value"))),
 #                            hr(),
                             fluidRow(column(10, verbatimTextOutput("value2"))),
                             hr(),
plotOutput("heatmapPlot")
#plotlyOutput("heatmapPlot")

                    ),
                    tabPanel(p(icon("line-chart"), "Hit Type Expectancy"),
#                             h4('Hit Type Expectancy', align = "left"),
                             plotlyOutput("hitPlot"),
                             hr(),
                             h4('Predict Event Based on Angle and Velocity', align = "left"),

                             numericInput("angle", "Launch Angle:", 25.1),
                             numericInput("velo", "Hit Velocity:", 95.5),
                             
                             helpText("Predict hit outcome based on angle/velo"),
                             fluidRow(column(10, verbatimTextOutput("eventtype")))
                             
                    ) # end of "Visualize the Data" tab panel

               )
          ),
       
          sidebarPanel(
          
#               sliderInput("bins",
#                           "Number of bins:",
#                           min = 1,
#                           max = 50,
#                           value = 30),
                   
               sliderInput("bins2",
                           "Date Chooser: (selector not yet implemented)",
                           min = as.Date('2015-04-01'),
                           max = as.Date('2015-10-01'),
                           value = c(as.Date('2015-04-04'),as.Date('2015-05-05'))),
               
               # Copy the chunk below to make a group of checkboxes
#               checkboxGroupInput("checkGroup", label = h4("Players:"), 
#                                  choices = list("Choice 1" = 1, "Choice 2" = 2, "Choice 3" = 3),
#                                  selected = NULL),
               uiOutput("playersControl") # the id
               
               #               checkboxGroupInput("playersGroup", "Players:",
               #                   players, selected = NULL
               #               ),
              
               ) #End sidebarPanel

          ) #End SidebarLayout


     )
)