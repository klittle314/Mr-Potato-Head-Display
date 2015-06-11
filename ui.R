
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
      h3 ("App Purpose"),
      helpText("This app displays data from the Mr. Potato Head simulation developed by Dr. Dave Williams",
               "of TrueSimple, LLC.   It is designed to be used during the simulation if data from team tests",
               "can be entered into a CSV file.  Visit www.truesimple.com for the Mr. Potato Head PDSA exercise."),
      h3 ("For questions about this web app"),
      helpText("Kevin Little, Ph.D., Informing Ecological Design, LLC, klittle@iecodesign.com.  Last update 11 June 2015",
               "code available on GitHub"),
      h3 ("")
      
      fileInput("fileInput","Upload CSV file with columns: Cycle, Team, Time, Accuracy",
                accept=c('text/csv', 'text/comma-separated-values,text/plain', '.csv'))
    ),

    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("ResultsPlot")
    )
  )
))
