#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

###THIs is the NEWEST
library(shiny)
library(plotly)
library(ggplot2)
library(hexbin)

source("data.R", local=TRUE)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  output$distPlot <- renderPlot({
    
    # generate bins based on input$bins from ui.R
    x    <- faithful[, 2] 
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
    #y <- input$date_range[1]
    
    #paste0('Dates are : ', input$date_range[1],' ',input$date_range[2])
    
    
  })
  
  output$heatmapPlot <- renderPlotly({
       cat("in render distplot")
       if(is.null(input$players))
            return()
       
       selectedplayer <- getDatabyPlayer(data2_tidy,input$players[1])

       p <- ggplot(selectedplayer, aes(px, pz, z = hit_speed)) + 
            stat_summary_hex(bins=50) +
            #         scale_fill_gradient(low = "#003366", high = "#ffa500") + theme_minimal() +  
            scale_fill_gradientn(colours = c("darkgreen", "gold", "red")) + theme_minimal() +
            labs(x = "Horizontal Axis",
                 y = "Vertical Axis",
                 title = "Exit Velocity Heatmap") + 
            
            geom_segment(x = inKzone, xend = inKzone, y = botKzone, yend = topKzone) +
            geom_segment(x = outKzone, xend = outKzone, y = botKzone, yend = topKzone) +
            geom_segment(x = inKzone, xend = outKzone, y = botKzone, yend = botKzone) +
            geom_segment(x = inKzone, xend = outKzone, y = topKzone, yend = topKzone)
       plot_ly(p) 
       
  })
  output$heatmapPlot <- renderPlot({
       if(is.null(input$players))
            return()
       
       selectedplayer <- getDatabyPlayer(data2_tidy,input$players[1])
       
       p <- ggplot(selectedplayer, aes(px, pz, z = hit_speed)) + 
            stat_summary_hex(bins=50) +
            #         scale_fill_gradient(low = "#003366", high = "#ffa500") + theme_minimal() +  
            scale_fill_gradientn(colours = c("darkgreen", "gold", "red")) + theme_minimal() +
            labs(x = "Horizontal Axis",
                 y = "Vertical Axis",
                 title = "Exit Velocity Heatmap") + xlim(-2.5, 2.5) + ylim(0,5) +
            
            geom_segment(x = inKzone, xend = inKzone, y = botKzone, yend = topKzone) +
            geom_segment(x = outKzone, xend = outKzone, y = botKzone, yend = topKzone) +
            geom_segment(x = inKzone, xend = outKzone, y = botKzone, yend = botKzone) +
            geom_segment(x = inKzone, xend = outKzone, y = topKzone, yend = topKzone)
       p
       
  })
  
  output$hitPlot <- renderPlotly({
       #pplot_ly(data = data2_tidy, x = hit_speed, y = hit_angle, mode = "markers", color=events, marker = list(opacity = 0.8, size = 4))
       selectedplayer <- getDatabyPlayer(data2_tidy,input$players[1])
       p <- plot_ly(selectedplayer, x = hit_speed, y = hit_angle, group = events, mode = "markers")
       p
       
  })
  
  # Initialize reactive values
  values <- reactiveValues()
  values$players <- players
  
  output$value <- renderPrint({ input$radio })

  # Create event type checkbox
  output$playersControl <- renderUI({
       radioButtons('players', 'Players:', 
               players, selected = NULL)
  })
  
  output$value2 <- renderPrint({ input$players })
  
  output$eventtype <- renderPrint({
       input$angle + input$velo
       type <- modeling(input$angle, input$velo)
       
       as.character(type)
  })
  
  output$mytable  <- renderDataTable(datatodisplay,
       options = list(
            pageLength = 10
       )
  )
  
})
