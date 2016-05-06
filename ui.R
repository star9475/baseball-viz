#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(stringr)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
     # Application title
     titlePanel("Coursera Project"),
  
     # Sidebar with a slider input for number of bins 
     sidebarLayout(
    
          # Show a plot of the generated distribution
          mainPanel(
               tabsetPanel(
                    tabPanel(p(icon("table"), "Data"),
                             h4('Insert Data table', align = "left"),
                             hr(),
                             fluidRow(column(10, verbatimTextOutput("value"))),
                             hr(),
                             fluidRow(column(10, verbatimTextOutput("value2"))),
                             hr(),
                             plotlyOutput("heatmapPlot")
                             
                    ),
                    tabPanel(p(icon("line-chart"), "Hitter Heatmaps"),
                             h4('Plotly Heat Map', align = "left"),
                             plotOutput("distPlot")
                    ) # end of "Visualize the Data" tab panel
                    
               )
          ),
       
          sidebarPanel(
          
               sliderInput("bins",
                           "Number of bins:",
                           min = 1,
                           max = 50,
                           value = 30),
                   
               sliderInput("bins2",
                           "Date Chooser:",
                           min = as.Date('2015-04-01'),
                           max = as.Date('2015-10-01'),
                           value = c(as.Date('2015-05-01'),as.Date('2015-09-01'))),
               
               # Copy the chunk below to make a group of checkboxes
               checkboxGroupInput("checkGroup", label = h4("Players:"), 
                                  choices = list("Choice 1" = 1, "Choice 2" = 2, "Choice 3" = 3),
                                  selected = NULL),
               uiOutput("playersControl") # the id
               
               #               checkboxGroupInput("playersGroup", "Players:",
               #                   players, selected = NULL
               #               ),
              
               ) #End sidebarPanel

          ) #End SidebarLayout


     )
)