#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @import semantic.dashboard
#' @import leaflet
#' @import shinyWidgets
#' @import tidyverse
#' @import highcharter
#' @noRd
app_ui <- function(request) {
  tagList(
    golem_add_external_resources(),
    fluidPage(class = "page_outer",
              fluidRow(class="logo",align="right",
                  tags$img(class="logo-image",src="www/ambulance-ambulanceemoji.gif",
                           alt="ambulance")),
              fluidRow(class = "page_inner",
                       uiOutput('main_stats',),
                       col_12(class= 'left',
                              fluidRow(class="switcher",
                                  col_3(class = "controls",prettyRadioButtons(
                                    inputId = "mode",
                                    label = "Stations:",
                                    choices = c( "All","Optimal"),
                                    inline = TRUE,
                                    status = "success",
                                    fill = TRUE,animation = "tada")
                                    ),
                                  col_4(class= "controls",
                                        dateRangeInput("period",label = "Days",
                                                       start = "2022-04-10",end = "2022-09-04",
                                                       min = "2022-04-10",
                                                       max = "2022-09-04",
                                                       width = "100%",autoclose = T)),
                                  col_2(class= "controls",prettyRadioButtons(
                                    inputId = "show_statitics",
                                    label = "Stats",
                                    choices = c( "Hide","Show"),
                                    inline = TRUE,
                                    status = "success",
                                    fill = TRUE,animation = "tada"))

                                  ),
                              leafletOutput("maps_out",height = "100%")  ),
                       col_2(class = 'right')
                       ),
    )
  )
}
#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )
  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "medserver"
    )
  )
}
