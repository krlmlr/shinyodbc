#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

  # Application title
  titlePanel("ODBC connectivity test"),

  sidebarLayout(
    sidebarPanel(
      uiOutput("driver_input"),
      uiOutput("data_source_input"),
      textAreaInput("extra_args", "Additional arguments"),
      verbatimTextOutput("connect_call"),
      textOutput("connect_call_ok"),
      actionButton("connect", "Connect"),
      actionButton("disconnect", "Disconnect"),
      verbatimTextOutput("connection")
    ),

    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(
        tabPanel("Drivers",
          DT::dataTableOutput("drivers")
        ),
        tabPanel("Data sources",
          DT::dataTableOutput("data_sources")
        )
      )
    )
  )
))
