
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(ggplot2)

shinyUI(fluidPage(
     
     # Application title
     titlePanel("Coursera Project"),
     
     # Sidebar with a slider input for number of bins
     sidebarLayout(
          
          
          # Show a plot of the generated distribution
          mainPanel(
               tabsetPanel(
#               h3('tests'),
#               plotOutput("distPlot")
#               h4('The mtcars data'),
                    tabPanel(p(icon("table"), "Data"),
                             dataTableOutput(outputId="mytable")
                    ),
                    tabPanel(p(icon("line-chart"), "Hitter Heatmaps"),
                             h5('Plotly Heatmap', align = "left"),
                             #textOutput("ggplot"),
                             #plotOutput("distPlot1"),
                             textOutput("plotly"),
                              plotlyOutput("distPlot")
                    ), # end of "Visualize the Data" tab panel
                    tabPanel(p(icon("line-chart"), "Hit Type Expectancy"),
                             h4('Plotly Hit Chart', align = "left"),
                             #textOutput("ggplot"),
                             #plotOutput("distPlot1"),
                             textOutput("plotly chart coming"),
                             plotlyOutput("hitPlot"),
                             # Copy the line below to make a number input box into the UI.
                             hr(),
                             
                             numericInput("angle", "Launch Angle:", 25.1),
                             numericInput("velo", "Hit Velocity:", 95.5),
                             
                             helpText("Predict hit outcome based on angle/velo"),
                             
                             submitButton("Update"),
                             fluidRow(column(3, verbatimTextOutput("value")))
                             
                             
                    ) # end of "Visualize the Data" tab panel
                    
               )    
          ),
          
          sidebarPanel(
               sliderInput("timeline", 
                           "Timeline:", 
                           min = 1950,
                           max = 2016,
                           value = c(1996, 2014)
                           ),
               
               sliderInput("date_range", 
                           "Choose Date Range:", 
                           min = as.Date("2015-04-01"), max = as.Date("2015-11-01"), 
                           value = c(as.Date("2015-06-01"), as.Date("2015-07-31"))
#                           value = c(as.Date("2016-04-10"), Sys.Date())
               ),
               sliderInput("future", 
                           "Future Slider:",
                           min = -1,
                           max = 5922,
                           value = c(271, 2448) 
               ),
               
#               uiInput("themesControl"), # the id
               checkboxGroupInput('players', 'Players:',
                   players, selected = NULL
               ),

               actionButton(inputId = "clearAll", 
                            label = "Clear selection", 
                            icon = icon("square-o")),
               actionButton(inputId = "selectAll", 
                            label = "Select all", 
                            icon = icon("check-square-o"))

                    # sliderInput("bins",
                    #        "Number of bins:",
                    #        min = 1,
                    #        max = 50,
                    #        value = 30)
          )
          
          
     )
))
