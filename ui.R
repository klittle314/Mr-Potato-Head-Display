
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
source("global.R")

shinyUI(fluidPage(

  # Application title
  titlePanel("Mr Potato Head Data Display"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      fileInput("fileInput","Upload CSV file",
                accept=c('text/csv', 'text/comma-separated-values,text/plain', '.csv'))
    ),

    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("ResultsPlot")
    )
  )
))
