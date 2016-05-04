
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(ggplot2)
library(plotly)

#data <- read.csv("data/baseball_savant429664.csv")
source("data.R")

shinyServer(function(input, output) {

#     output$distPlot <- renderPlot({
     output$distPlot <- renderPlotly({
               if(is.null(input$players))
            return()

     selectedplayer <- getDatabyPlayer(data,input$players[1])
     p <- ggplot(selectedplayer, aes(px, pz, z = batted_ball_velocity))+ 
          stat_summary_hex(bins=50) + 
#         scale_fill_gradient(low = "#003366", high = "#ffa500") + theme_minimal() +  
          scale_fill_gradientn(colours = c("darkgreen", "gold", "red")) + theme_minimal() +
          labs(size= "Nitrogen",
               x = "My x label\n\n",
               y = "My y label",
               title = "Title") +
     
          geom_segment(x = inKzone, xend = inKzone, y = botKzone, yend = topKzone) +
          geom_segment(x = outKzone, xend = outKzone, y = botKzone, yend = topKzone) +
          geom_segment(x = inKzone, xend = outKzone, y = botKzone, yend = botKzone) +
          geom_segment(x = inKzone, xend = outKzone, y = topKzone, yend = topKzone)
     # p2 <- ggvis(test, props(px, pz, z = batted_ball_velocity))
     # #p
     #ggplotly(p)
     #plot_ly(x = test$px, y = test$pz, type = "histogram2d")
     m = list(l = 50,r = 50,b = 100,t = 100,pad = 4)
     plot_ly(p) #%>% layout(autosize = F, width = 400, height = 400)
     
  })

     output$hitPlot <- renderPlotly({
          #pplot_ly(data = data2_tidy, x = hit_speed, y = hit_angle, mode = "markers", color=events, marker = list(opacity = 0.8, size = 4))
          hp <- plot_ly(data2_tidy, x = hit_speed, y = hit_angle, group = events,
                        xaxis = paste0("x", id), mode = "markers", marker = list(opacity = 0.6, size = 4)) 
          hp <- layout(
               xaxis = list(range = c(0, 120)),
               yaxis = list(range = c(-50, 50)))
          hp2 <- subplot(p, nrows = 3)
          hp2
          
     })

     
     output$distPlot1 <- renderPlot({
          if(is.null(input$players))
               return()
          
          selectedplayer <- getDatabyPlayer(data,input$players[1])
          p <- ggplot(selectedplayer, aes(px, pz, z = batted_ball_velocity))+ stat_summary_hex(bins=50) + scale_fill_gradient(low = "#003366", high = "#ffa500") + theme_minimal() +  geom_segment(x = inKzone, xend = inKzone, y = botKzone, yend = topKzone) +
               geom_segment(x = outKzone, xend = outKzone, y = botKzone, yend = topKzone) +
               geom_segment(x = inKzone, xend = outKzone, y = botKzone, yend = botKzone) +
               geom_segment(x = inKzone, xend = outKzone, y = topKzone, yend = topKzone)
          # p2 <- ggvis(test, props(px, pz, z = batted_ball_velocity))
          p
          #ggplotly(p)
          #plot_ly(x = test$px, y = test$pz, type = "histogram2d")
          #plot_ly(p)
          
     })
     
  output$mytable  <- renderDataTable(datatodisplay,
       options = list(
            pageLength = 5
       )
  )
  
  # Initialize reactive values
#  values <- reactiveValues()
#  values$players <- players
  
  # Create event type checkbox
#  input$themesControl <- renderUI({
#       checkboxGroupInput('players', 'Players:', 
#                          players, selected = NULL)
#                         players, selected = values$players)
#  })
  # Add observer on select-all button
  observe({
       if(input$selectAll == 0) return()
       values$players <- players
  })
  
  # Add observer on clear-all button
  observe({
       if(input$clearAll == 0) return()
       values$players <- c() # empty list
  })
  # Prepare dataset
  dataToPlot <- reactive({
       getDatabyPlayer(data, input$players)
  })
  output$test <- renderText({
       # Simply accessing input$goButton here makes this reactive
       # object take a dependency on it. That means when
       # input$goButton changes, this code will re-execute.
       input$players
       
       # input$text is accessed here, so this reactive object will
       # take a dependency on it. However, input$ is inside of
       # isolate(), so this reactive object will NOT take a
       # dependency on it; changes to input$n will therefore not
       # trigger re-execution.
       paste0('Player selected :', input$players, '\nand Dates are : ', input$date_range[1],' ',input$date_range[2])
  })  

  # Show the first "n" observations
  output$value <- renderPrint({
       input$angle + input$velo
       type <- modeling(input$angle, input$velo)
       
       as.character(type)
     })
  
})

