library(shiny)
shinyUI(fluidPage(
  tags$head(
    tags$style(HTML(
      " body {
        background-color: #ebebeb;
        }"
    ))
  ),
  tags$head(includeScript("google-analytics.js")),
  tabsetPanel(
    tabPanel("Top movies",
             fluidRow(column(5),
                      column(4,
                             sliderInput("year3", "", min = min(boxoffice$year, na.rm = TRUE), 
                                         max = max(boxoffice$year, na.rm = TRUE), value = c(2000, 2016))
                             ), column(3)),

             plotOutput("plot_years", height = "600px")
    ),
    tabPanel("Studio movies",
             fluidRow(column(3), 
                      column(3,
                             selectInput("studio_movies", "", choices = c("",unique(boxoffice$studio)), 
                                         selected = "BV")
                             ),
                      column(3,
                             sliderInput("year2", "", min = min(boxoffice$year, na.rm = TRUE), 
                                         max = max(boxoffice$year, na.rm = TRUE), value = c(2000, 2016))
                             )),
             plotOutput("plot_movies", height = "600px")
    ),
    tabPanel("Studio sales",
             fluidRow(column(2), 
                      column(3,
                             selectizeInput("studio","", choices = unique(boxoffice$studio), 
                                            multiple = TRUE, selected = c("BV", "Fox"))
                             ),
                      column(3, br(),
                             checkboxInput("facet_studio", "Separate studios")
                             ), 
                      column(4,
                             sliderInput("year", "", min = min(boxoffice$year, na.rm = TRUE), 
                                         max = max(boxoffice$year, na.rm = TRUE), value = c(2000, 2016))
                             )),
             plotOutput("plot", height = "600px")
    )
  ),
tags$a(href="http://www.boxofficemojo.com/alltime/domestic.htm", "Data source: Box Office Mojo")
))