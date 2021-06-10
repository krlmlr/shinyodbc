#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  drivers <- odbc::odbcListDrivers()
  data_sources <- odbc::odbcListDataSources()

  output$driver_input <- renderUI(selectizeInput(
    "driver", "Driver", choices = c(drivers$name)
  ))

  output$data_source_input <- renderUI(selectizeInput(
    "data_source", "Data source", choices = c("", data_sources$name)
  ))

  output$drivers <- DT::renderDataTable(drivers)
  output$data_sources <- DT::renderDataTable(data_sources)

  connect_call_text <- reactive(get_call_text(input$driver, input$data_source, input$extra_args))
  connect_call <- reactive(get_call(connect_call_text()))

  output$connect_call <- renderPrint(tryCatch(
    writeLines(connect_call_text()),
    error = function(e) invisible()
  ))
  output$connect_call_ok <- renderText({
    # Called for side effect
    connect_call()
    ""
  })
})

get_call_text <- function(driver, data_source, extra_args) {
  if (driver == "") stop("Please select a driver.")
  paste0(
    "DBI::dbConnect(",
    ",\n  odbc::odbc()",
    ',\n  drv = "', driver, '"',
    if (data_source != "") paste0(',\n  dsn = "', data_source, '"'),
    if (extra_args != "") paste0(",\n  ", gsub("\n", "\n  ", extra_args)),
    "\n)"
  )
}

get_call <- function(text) {
  req(text)
  parse(text = text)
}
