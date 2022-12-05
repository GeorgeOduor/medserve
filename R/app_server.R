#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @import tidyverse
#' @import leaflet
#' @import tibble
#' @import dplyr
#' @import lubridate
#' @import highcharter
#' @import kableExtra
#' @noRd
app_server <- function(input, output, session) {

  points <- reactive({

    rd_eoc_data_Arranged %>%
      mutate(DATE = as.Date(DATE),
             Day = round(day(DATE)/7),
             Week = ifelse(Day >4,4,ifelse(Day == 0,1,Day)),
      ) %>%
      filter(DATE >= input$period[1],DATE <= input$period[2])
  })

  output$maps_out <- renderLeaflet({
    if (input$mode == "All") {
      points() %>%
        leaflet() %>%
        addProviderTiles(providers$OneMapSG.Grey) %>%
        addTiles() %>%
        addMarkers(
          lng = ~ lon,
          lat = ~ lat,
          clusterOptions = markerClusterOptions(),
          icon = customicon,popup = ~ Details,
          label = ~ addresses
        )
    }else{
      optimalsites %>%
        leaflet() %>%
        addProviderTiles(providers$OneMapSG.Grey) %>%
        addTiles() %>%
        addMarkers(
          lng = ~ longitude,
          lat = ~ latitude,
          clusterOptions = markerClusterOptions(),
          icon = customicon,popup = ~ glue::glue("<p>NumberOfAmbulances :{NumberOfAmbulances}</p>"),
          label = ~ Site.name
        ) %>% addCircles(lng = ~ longitude,lat = ~ latitude)
    }

  })

  output$chart_out <- renderHighchart({

    if (input$driller == "Monthly") {
      points() %>%
        group_by(Month = month(DATE,T)) %>%
        summarise(Count = n())  %>%
        hchart("column",hcaes(Month,Count)) %>%
        hc_colors("red") %>%
        hc_title(text = "Monthly Trend")
    }else if (input$driller == "Weekly") {
      points() %>%
        group_by(Month = month(DATE,T),Week = paste("Week",Week)) %>%
        summarise(Count = n())  %>%
        hchart("column",hcaes(Month,Count,group="Week")) %>%
        # hc_colors("red") %>%
        hc_title(text = "Weekly Trend")
    }else{
      points()  %>%
        group_by(Day = as.Date(DATE)) %>%
        summarise(Count = n())  %>%
        hchart("spline",hcaes(Day,Count)) %>%
        hc_colors("red") %>%
        hc_title(text = "Daily Trend")
    }
  })
  output$responsetime <- function(){
    points() %>%
      group_by(Day = tolower(DAY)) %>%
      summarise(Requested = n()) %>%
      kable() %>%
      kable_styling(font_size = 14)
  }
  output$main_stats <- renderUI({
    # prepare data====
    dataset_file <- points()

    # prepare ui
    ui <- div(class = "main_stat",align = "right",
        fluidRow(class = "highchart",
                 radioGroupButtons(
                   inputId = "driller",
                   label = "View By:",
                   choices = c(datasetprop(dataset_file)),
                   justified = TRUE,size = "xs",status = "success",
                 ),hr(),
                 highchartOutput("chart_out",height="200px")
                 ),
        fluidRow(class = "adhoc",tableOutput("responsetime"))
    )
    if (input$show_statitics == "Show") {
      ui
    }
  })
}
