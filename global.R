
library(googleVis)
library(xlsx)
library(reshape2)
library(dplyr)
library(ggplot2)
library(GGally)
library(gtable)
library(gridExtra)

# df10 <- read.xlsx("Potato_Head_7_June.xlsx",sheetIndex=1,endRow=56,
#                   colIndex=c(1:4),stringsAsFactors=FALSE)

plot_maker <- function(data_frame,yvar,title1,yname) {
  df10 <- data_frame
  p1 <- ggplot(data=df10,aes_string(x="Cycle",y=yvar))+
    theme_bw()+
    geom_point(size=rel(3.0))+
    geom_line()+
    ggtitle(title1)+
    theme(plot.title=element_text(size=rel(1.25)))+
    ylab(yname)+
    xlab("")+
    theme(axis.text.y=element_text(size=rel(1.0)))+
    theme(axis.text.x=element_text(size=rel(1.15)))+
    theme(axis.title=element_text(size=rel(1.5)))+
   # scale_x_continuous(breaks=c(1:max(df10$Cycle)))+
    facet_wrap(~Team)

#   p2 <- ggplot(data=df10,aes(x=Cycle,y=Accuracy))+
#     theme_bw()+
#     geom_point(size=rel(3.0))+
#     geom_line()+
#     ggtitle("Accuracy")+
#     theme(plot.title=element_text(size=rel(1.25)))+
#     theme(axis.text.y=element_text(size=rel(1.0)))+
#     theme(axis.text.x=element_text(size=rel(1.15)))+
#     theme(axis.title=element_text(size=rel(1.5)))+
#     scale_y_continuous(breaks=c(1:3))+
#     ylab("Score")+
#     #/jk.scale_x_continuous(breaks=c(1:max(df10$Cycle)))+
#     facet_wrap(~Team)
#   
# #   p3 <- grid.arrange(p1,p2, main="Mr Potato Head CHILA 7 June 2015")
#     return(p1)
}
