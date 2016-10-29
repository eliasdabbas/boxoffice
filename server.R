library(shiny)
shinyServer(function(input, output) {

  output$plot <- renderPlot({
    plotdata <- reactive({
      boxoffice_sum %>% 
        filter(studio %in% input$studio, 
               year >= range(input$year)[1], 
               year <= range(input$year)[2])
    })
    
    output$plot <- renderPlot({
      p <- ggplot(plotdata(), 
             aes(year, gross, group = studio, col = studio)) +
        geom_line(size = 1) +
        geom_point(size = 5) +
        labs(x = NULL, y = NULL) +
        scale_y_continuous(labels = scales::comma) +
        theme_elias
      if(input$facet_studio) {
        p <- p + facet_wrap(~studio, scales = "free_y")
      }
      print(p)
    })

  })
  
  output$plot_movies <- renderPlot({
    boxoffice %>% 
      filter(studio == input$studio_movies,
             year >= range(input$year2)[1], 
             year <= range(input$year2)[2]) %>% 
      ggplot(aes(year, lifetime_gross)) +
      geom_point() +
      geom_text_repel(data = . %>% top_n(20, wt = lifetime_gross), 
                      aes(label = title), force = 2) +
      labs(x = NULL, y = NULL) +
      scale_y_continuous(labels = scales::comma) +
      theme_elias 
  })
  
  output$plot_years <- renderPlot({
    boxoffice %>% 
      filter(year >= range(input$year3)[1], 
             year <= range(input$year3)[2]) %>% 
      ggplot(aes(year, lifetime_gross)) +
      geom_dotplot(dotsize = 0.01, alpha = 0.1) +
      geom_text_repel(data = . %>% top_n(20, wt = lifetime_gross), 
                      aes(label = title, color = studio)) +
      geom_jitter(width = 0.3) +
      labs(x = NULL, y = NULL) +
      scale_y_continuous(labels = scales::comma) +
      theme_elias +
      guides(color = guide_legend(override.aes = list(size = 10, face = "bold"))) +

      viridis::scale_color_viridis(discrete  = T, option = "B")
  })
  
})
