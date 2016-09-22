
# ui.R
# Kevin Little, Ph.D. Informing Ecological Design, LLC  11 June 2015

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
               "of TrueSimple, LLC.   It is designed to be used during the simulation if Time and Accuracy data from team tests",
               "can be entered into a CSV file.  Visit www.truesimple.com for the Mr. Potato Head PDSA exercise."
               ),
      h3 ("For questions about this web app"),
      helpText("Kevin Little, Ph.D., Informing Ecological Design, LLC, klittle@iecodesign.com.  Last update 11 June 2015",
               "code available on GitHub."),
      h3 (""),
      
      textInput("text", label = h3("Create the data display"), value = "Enter title for small multiples display..."),
      
      fileInput("fileInput","Upload CSV file with columns: Cycle, Team, Time, Accuracy",
                accept=c('text/csv', 'text/comma-separated-values,text/plain', '.csv')),
      helpText("Click Download display button to get a .png version of the small multiples display."),
      downloadButton("downloadDisplay","Download display"),
      br(),
      br(),
      helpText("Adjust size of the plotted point"), 
                   # Simple integer interval for width and height of graph
                   sliderInput("size", "size:", 
                               min=3, max=5, value=4),
      width=3
    ),

    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("ResultsPlot")
    )
  )
))
