library(shiny)
shinyServer(function(input, output) {

  output$plot <- renderPlot({
    plotdata <- reactive({
      boxoffice_sum %>% 
        filter(studio_name %in% input$studio, 
               year >= range(input$year)[1], 
               year <= range(input$year)[2])
    })
    
    output$plot <- renderPlot({
      p <- ggplot(plotdata(), 
             aes(year, gross / 1000000, group = studio_name, col = studio_name, fill = studio_name)) +
        geom_line(size = 1) +
        geom_point(size = 5) +
        geom_ribbon(aes(ymax = gross / 1000000, ymin = 0), alpha = 0.1) +
        labs(x = NULL, y = NULL) +
        scale_y_continuous(labels = scales::comma) +
        ggtitle("Annual gross per studio $US million") +
        theme_elias
      if(input$facet_studio) {
        p <- p + facet_wrap(~studio_name, scales = "free_y")
      }
      print(p)
    })

  })
  
  output$plot_movies <- renderPlot({
    boxoffice %>% 
      filter(studio_name == input$studio_movies,
             year >= range(input$year2)[1], 
             year <= range(input$year2)[2]) %>% 
      ggplot(aes(year, lifetime_gross / 1000000)) +
      geom_point() +
      geom_label_repel(data = . %>% top_n(20, wt = lifetime_gross), 
                      aes(fill = rank, label = paste0(title, " (", rank, ")")),
                      size = 6) +
      scale_fill_gradient(low = "deepskyblue2", high = "grey92") +
      labs(x = NULL, y = NULL, caption = "(numbers): lifetime rank of movie") +
      ggtitle(label = paste0(input$studio_movies, ": lifetime gross per movie $US million")) +
      scale_y_continuous(labels = scales::comma) +
      theme_elias +
      theme(legend.position = "none") 
  })
  
  output$plot_years <- renderPlot({
    boxoffice %>% 
      filter(year >= range(input$year3)[1], 
             year <= range(input$year3)[2]) %>% 
      ggplot(aes(year, lifetime_gross / 1000000)) +
      geom_point(alpha = 0.1) +
      geom_label_repel(data = . %>% top_n(20, wt = lifetime_gross), 
                       fill = "grey95", size = 6,
                      aes(label = paste0(title, " (", rank, ")"), color = studio_name)) +
      geom_jitter(width = 0.2) +
      labs(x = NULL, y = NULL, caption = "(numbers): lifetime rank of movie") +
      scale_y_continuous(labels = scales::comma) +
      ggtitle(paste0("Lifetime gross per movie $US million")) +
      theme_elias +
      guides(color = guide_legend(override.aes = list(size = 10, face = "bold"))) #+

      #viridis::scale_color_viridis(discrete  = T, option = "D")
  })
  
})