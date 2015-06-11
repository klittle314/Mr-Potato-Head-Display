
# server.R 
# 
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
  
  
 
  p_time <- reactive({
    inFile <- input$fileInput
    if(is.null(inFile)) {
      #user has not yet uploaded a file yet
      return(NULL)
    } else {
        p_out <- plot_maker(data_frame=df1(),yvar="Time",title1="Time",yname="Seconds",xlab="")
    }
  })
  
   p_accuracy <- reactive({
     inFile <- input$fileInput
     if(is.null(inFile)) {
       #user has not yet uploaded a file yet
       return(NULL)
     } else { 
        p_out <- plot_maker(data_frame=df1(),yvar="Accuracy",title1="Accuracy",yname="Score",xlab="PDSA cycle")
     }
   })
  
   p_both <- reactive({
     inFile <- input$fileInput
     if(is.null(inFile)) {
       #user has not yet uploaded a file yet
       return(NULL)
     } else { 
       title1 <- input$text   
       p_out <- grid.arrange(p_time(),p_accuracy(),main= textGrob(title1,
                                          gp=gpar(fontsize=16)))
     }
   })

  output$ResultsPlot <- renderPlot({
        print(p_both())
    
  },width=600,height=800)
 
  #suggestion https://groups.google.com/forum/#!topic/shiny-discuss/u7gwXc8_vyY by Patrick Renschler 2/26/14
  p_both2 = function(){
    inFile <- input$fileInput
    if(is.null(inFile)) {
      #user has not yet uploaded a file yet
      return(NULL)
    } else { 
      title1 <- input$text   
      p_out <- grid.arrange(p_time(),p_accuracy(),main= textGrob(title1,
                                                                 gp=gpar(fontsize=16)))
    }
  }

  output$downloadDisplay <- downloadHandler(
#     filename = function() {
#       paste0(input$text,"_plot_",Sys.Date(),".png")},
    filename=paste0("Mr_Potato_Head_display_",Sys.Date(),".png"),
    content <- function(file) {
      png(file,width=600,height=800)
      p_both2()
      dev.off()},
    contentType = "image/png"
  )   
# }
#    })
})
