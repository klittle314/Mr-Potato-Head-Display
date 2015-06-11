#server.R
source("helper functions.R")
source("global.R")

shinyServer(function(input, output) {

 
ga.start <- reactive({
   input$dateRange[1] 
 })

ga.end <- reactive({
  input$dateRange[2]
})

med.start <- reactive({
  ms <- input$dateRangeM[1]
})

med.end <- reactive({
  me <- input$dateRangeM[2]
})

# output$start <- renderText({as.character(as.Date(ga.start()))})
# output$end <- renderText({as.character(as.Date(ga.end()))})

#create a reactive dataframe using the input date range
ga.data <- reactive({
  start1 <- as.Date(ga.start())
  end1 <- as.Date(ga.end())
  data_out <- ga.dataA[ga.dataA$Date >= start1 & ga.dataA$Date <= end1,]
})



 
#create reactive reference medians.  It appears that function calls cannot have more than one "direct" reactive argument.
ref_medPct <- reactive({
  d10 <- as.Date(med.start())
  d20 <- as.Date(med.end())
  ref1 <- make_med(df=ga.dataA,y_idx=y_idx3,d1=d10,d2=d20)
})

ref_medSK <- reactive({
  d10 <- as.Date(med.start())
  d20 <- as.Date(med.end())
  ref2 <- make_med(df=ga.dataA,y_idx=y_idx2,d1=d10,d2=d20)
})

ref_medTV <- reactive({
  d10 <- as.Date(med.start())
  d20 <- as.Date(med.end())
  ref3 <- make_med(df=ga.dataA,y_idx=y_idx1,d1=d10,d2=d20)
})

ref_medAbEst <- reactive({
  d10 <- as.Date(med.start())
  d20 <- as.Date(med.end())
  ref4 <- make_med(df=ga.dataA,y_idx=y_idx6,d1=d10,d2=d20)
})

ref_medSubDL <- reactive({
  d10 <- as.Date(med.start())
  d20 <- as.Date(med.end())
  ref5 <- make_med(df=ga.dataA,y_idx=y_idx5,d1=d10,d2=d20)
})

ref_medAttDL <- reactive({
  d10 <- as.Date(med.start())
  d20 <- as.Date(med.end())
  ref6 <- make_med(df=ga.dataA,y_idx=y_idx4,d1=d10,d2=d20)
})

#make the base file of notes reactive
df_notes <- reactive({
  df_out <- df_notes_base
})

#define the upload file and extract the annotations from the annotation file to add to the plot
#need to error trap bad format of uploaded file for complete generality
df_notes2 <- reactive({
  inFile <- input$files
  if (is.null(inFile)) {
    # User has not uploaded a file yet
    return(NULL)
  }
  data_notes2 <- read.csv(inFile$datapath, header=T, stringsAsFactors =F)
  data_notes2$Start_Date <- as.Date(data_notes2$Start_Date,format="%m/%d/%Y")
  data_notes2$End_Date <- as.Date(data_notes2$End_Date,format="%m/%d/%Y")
  return(data_notes2)
})

#here is where I should merge the notes files.
df_notes3 <- reactive({
  inFile <- input$files
  if(!is.null(inFile)) {
    df_out <- df_notes()
  } else {
    df_out <- rbind.data.frame(df_notes(),df_notes2())
  }
  return(df_out)
})

#define the table for output verification
output$file_notes <- renderDataTable({
  df_out <- df_notes3()
})

#subset the notes dataframe to align with the data display
df_notes1 <- reactive({
  df_out <- df_notes3()[df_notes3()$Start_Date >= min(ga.data()$Date) &
                          df_notes3()$Start_Date <= max(ga.data()$Date),]
})

# #set up overlay rectangles for the plots as a reactive dataframe
dfrect <- reactive({
  df_out <- data.frame(
    xmin = df_notes1()$Start_Date - .40,
    xmax = df_notes1()$End_Date + .40,
    ymin = -Inf,
    ymax = Inf)
  
  return(df_out)
})

#set up coordinates for the plot annotations as a reactive dataframe
dftext <- reactive({
  df_text <- data.frame(
    xtext = df_notes1()$Start_Date + floor((df_notes1()$End_Date-df_notes1()$Start_Date)/2),
    ytext1 = .95*max(ga.data()[,y_idx3],na.rm=TRUE),
    ytext2 = .95*max(ga.data()[,y_idx2],na.rm=TRUE),
    ytext3 = .95*max(ga.data()[,y_idx1],na.rm=TRUE),
    ytext4 = .95*max(ga.data()[,y_idx6],na.rm=TRUE),
    ytext5 = .95*max(ga.data()[,y_idx5],na.rm=TRUE),
    ytext6 = .95*max(ga.data()[,y_idx4],na.rm=TRUE),
    #program a line break after so many characters?
    label = df_notes1()$Event_description)
  return(df_text)
})

#create reactive plot objects, conditional on the presence of the annotation file

p0p <- reactive({
  if(is.null(df_notes())){
    pz <- pmed1(df=ga.data(),y_idx=y_idx3,title2=Titles[3]) #+ geom_text(x=x1,y=25,label="Jan Death over Dinner",size=3)
    pz1 <- pz + geom_hline(yintercept=ref_medPct(),lty=2) 
  } else {
    pz <- pmed1(df=ga.data(),y_idx=y_idx3,title2=Titles[3]) 
    pz1 <- pz + geom_hline(yintercept=ref_medPct(),lty=2) 
    pz1.1 <- pz1 + geom_rect(data=dfrect(),aes(NULL,NULL,xmin=xmin,xmax=xmax,ymin=ymin,ymax=ymax),fill="gray80",alpha=0.5)
    pz1.2 <- pz1.1 + geom_text(data=dftext(),aes(x=xtext,y=ytext1,label=label),size=4)
  }
  })

p0SK <- reactive({
  if(is.null(df_notes())) {
    py <- pmed1(df=ga.data(),y_idx=y_idx2,title2=Titles[1]) 
    py1 <- py + geom_hline(yintercept=ref_medSK(),lty=2)
  } else {
    py <- pmed1(df=ga.data(),y_idx=y_idx2,title2=Titles[1]) 
    py1 <- py + geom_hline(yintercept=ref_medSK(),lty=2)
    py1.1 <- py1 + geom_rect(data=dfrect(),aes(NULL,NULL,xmin=xmin,xmax=xmax,ymin=ymin,ymax=ymax,linetype="dashed"),
                             fill=c("gray80"),alpha=0.5)
    #py1.2 <- py1.1 + geom_text(data=dftext(),aes(x=xtext,y=ytext2,label=label),size=4)
  }
    
})  

p0TNU <- reactive({
  if(is.null(df_notes())) {
    px <- pmed1(df=ga.data(),y_idx=4,title2=Titles[2])
    px1 <- px + geom_hline(yintercept=ref_medTV(),lty=2)
  } else {
    px <- pmed1(df=ga.data(),y_idx=4,title2=Titles[2])
    px1 <- px + geom_hline(yintercept=ref_medTV(),lty=2)
    px1.1 <- px1 + geom_rect(data=dfrect(),aes(NULL,NULL,xmin=xmin,xmax=xmax,ymin=ymin,ymax=ymax),fill="gray80",alpha=0.5)
    #px2.2 <- px1.1 + geom_text(data=dftext(),aes(x=xtext,y=ytext3,label=label),size=4)
  }
})


#render the plot for display, conditional on the annotation file being loaded.
output$main_plot <- renderPlot({
    pall0 <- grid.arrange(p0p(),p0SK(),p0TNU(), 
                        #main=paste0("Summary of Download Activity, TCP website ",min(ga.data()$Date)," - ",max(ga.data()$Date)),
                      main="Summary of Download Activity, TCP website" , 
                      ncol=1)
   print(pall0)
  })


#make the abandon rate plot
pap <- reactive({
  if(is.null(df_notes())){
    pz4 <- pmed1(df=ga.data(),y_idx=y_idx6,title2=Titles[4]) #+ geom_text(x=x1,y=25,label="Jan Death over Dinner",size=3)
    pz41 <- pz4 + geom_hline(yintercept=ref_medAbEst(),lty=2) 
  } else {
    pz4 <- pmed1(df=ga.data(),y_idx=y_idx6,title2=Titles[4]) 
    pz41 <- pz4 + geom_hline(yintercept=ref_medAbEst(),lty=2) 
    pz41.1 <- pz41 + geom_rect(data=dfrect(),aes(NULL,NULL,xmin=xmin,xmax=xmax,ymin=ymin,ymax=ymax),fill="gray80",alpha=0.5)
    pz41.2 <- pz41.1 + geom_text(data=dftext(),aes(x=xtext,y=ytext4,label=label),size=4)
  }
})

#make the subscriber download plot
paSDL <- reactive({
  if(is.null(df_notes())){
    pz5 <- pmed1(df=ga.data(),y_idx=y_idx5,title2=Titles[5]) #+ geom_text(x=x1,y=25,label="Jan Death over Dinner",size=3)
    pz51 <- pz5 + geom_hline(yintercept=ref_medSubDL(),lty=2) 
  } else {
    pz5 <- pmed1(df=ga.data(),y_idx=y_idx5,title2=Titles[5]) 
    pz51 <- pz5 + geom_hline(yintercept=ref_medSubDL(),lty=2) 
    pz51.1 <- pz51 + geom_rect(data=dfrect(),aes(NULL,NULL,xmin=xmin,xmax=xmax,ymin=ymin,ymax=ymax),fill="gray80",alpha=0.5)
    #pz51.2 <- pz51.1 + geom_text(data=dftext(),aes(x=xtext,y=ytext5,label=label),size=4)
  }
})

#make plot of attempted downloads
paADL <- reactive({
  if(is.null(df_notes())){
    pz6 <- pmed1(df=ga.data(),y_idx=y_idx4,title2=Titles[6]) #+ geom_text(x=x1,y=25,label="Jan Death over Dinner",size=3)
    pz61 <- pz6 + geom_hline(yintercept=ref_medAttDL(),lty=2) 
  } else {
    pz6 <- pmed1(df=ga.data(),y_idx=y_idx4,title2=Titles[6]) 
    pz61 <- pz6 + geom_hline(yintercept=ref_medAttDL(),lty=2) 
    pz61.1 <- pz61 + geom_rect(data=dfrect(),aes(NULL,NULL,xmin=xmin,xmax=xmax,ymin=ymin,ymax=ymax),fill="gray80",alpha=0.5)
    #     df_text <- data.frame(
    #       xtext = df_notes()$Start_Date,
    #       ytext = .9*max(ga.data()[,12],na.rm=TRUE),
    #       label = df_notes()$Test_description)
    #pz61.2 <- pz61.1 + geom_text(data=dftext(),aes(x=xtext,y=ytext6,label=label),size=4)
  }
})

#create the abandon rate display
output$abd_plot <- renderPlot({
  palla <- grid.arrange(pap(),paSDL(),paADL(), 
                        #main=paste0("Summary of Download Activity, TCP website ",min(ga.data()$Date)," - ",max(ga.data()$Date)),
                        main="Summary of Attempted Downloads, TCP website" , 
                        ncol=1)
 
  print(palla)
})

#create table object for display
table_out <- reactive({
  #tdate <- as.character(as.Date(ga.data()$Date))
  tdata <- ga.data()[,var_names]
  tdata[,5] <- formatC(tdata[,5],format="f",digits=1)
  names(tdata) <- c("Date","Day_of_Week","Non-unique_visitors","SK_downloads","Pct_downloads","Attmt_downloads","Pct_abandon")
  return(tdata)
})

 
#render the Data Table for display (note that the function renderTable is plain HTML and doesn't handle Date objects directly)
output$table <- renderDataTable({
  table_out()
})

#create the file for download
output$downloadData <- downloadHandler(
  filename = function() {
    paste('TCP_downloads_', Sys.Date(), '.csv', sep='')
  },
    content = function(file) {
      write.csv(ga.data()[,var_names], file, row.names=FALSE)
    }
  )
 })

