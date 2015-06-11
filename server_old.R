
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
source("global.R")

shinyServer(function(input, output) {
  df1 <- reactive({
    inFile <- input$fileInput
    if(is.null(inFile)) {
      #user has not yet uploaded a file yet
      return(NULL)
    }
    df_use <- read.csv(inFile$datapath,header=T)
    return(df_use)
  })
 
  p_time < reactive({
    df2 <- df1()
    if(is.null(df2)) {
       return(NULL)
    } else {
        p_out <- plot_maker(data_frame=df2,yvar="Time",title1="Time",yname="Seconds")
    }
  })
  
   p_accuracy <- reactive({
     df2 <- df1()
     if(is.null(df2)) {
       return(NULL)
     } else { 
        p_out <- plot_maker(data_frame=df2,yvar="Accuracy",title1="Accuracy",yname="Score")
     }
   })
  
   p_both <- reactive({
     df2 <- df1()
     if(is.null(df2)) {
       return(NULL)
     } else { 
          p_out <- grid.arrange(p_time(),p_accuracy(),main=
                                  textGrob(paste0("Mr. Potato Head PDSA Record ", Sys.Date()),
     }                                      gp=gpar(fontsize=16)))
    
 output$ResultsPlot <- renderPlot({
   df2 <- df1()
   if(is.null(df2)) {
     return(NULL)
   } else {
    p1 <- grid.arrange(p_time(),p_accuracy(),main=
                        textGrob(paste0("Mr. Potato Head PDSA Record ", Sys.Date()),
                                 gp=gpar(fontsize=16)))
    print(p1)
   }
  },width=600,height=800)
})
