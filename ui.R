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

# Define UI for application 
shinyUI(fluidPage(theme = "bootstrap.css",
  
     # Application title
     titlePanel("Coursera Developing Data Project - Mariners Viz"),
  
     # Sidebar Layout
     sidebarLayout(
    
          # Show a plot of the generated distribution
          mainPanel(
               tabsetPanel(
#                    tabPanel(p(icon("table"), "Explore the Data"),
#                             h4('data', align = "left"),
#                             dataTableOutput(outputId="mytable")
#                    ),
                    tabPanel(p(icon("info"), "About"),
                             includeMarkdown("about.Rmd")
                    ), # end of "Visualize the Data" tab panel
                    tabPanel(p(icon("line-chart"), "Heatmaps"),
#                            fluidRow(column(10, verbatimTextOutput("value"))),
#                            hr(),
                             fluidRow(column(10, verbatimTextOutput("value2"))),
                             hr(),
                              plotOutput("heatmapPlot")
                              #plotlyOutput("heatmapPlot")

                    ),
                    tabPanel(p(icon("line-chart"), "Hit Type Expectancy"),
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
               

               ) #End sidebarPanel

          ) #End SidebarLayout


     )
)