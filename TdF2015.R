#### Tour de France 2015 plot ####
## Visualisation of the 2015 Tour de France results
## Data comes from Martin Theus
## This version:  15-10-2015
## First version: 04-07-2015

## Load the data 
tdf<- read.table(url("http://www.theusrus.de/Blog-files/TDF2015.txt"), 
                 header=T, sep="\t", quote="")


#### Time-trial results (Stage 1) ####
x<-sort(tdf$S1)
par(mar=c(4,2,8,2),bg="black",family="serif")
plot(x,rep(1,198),type="h",axes=FALSE,xlab="",ylab="",lwd=5,col="yellow",
     main="Stage 1 (13.8 Km) \n Utrecht / Utrecht",cex.main=2, col.main="white")

## Indicators for various times
text(x[1],1.1,"14m56s",cex=1.2,col="white");segments(x[1],1.01,x[1],1.08,lwd=2,col="white")
text(x[5],1.1,"+15s",cex=1.2,col="white");segments(x[5],1.01,x[5],1.08,lwd=2,col="white")
text(x[8],1.1,"+29s",cex=1.2,col="white");segments(x[8],1.01,x[8],1.08,lwd=2,col="white")
text(x[99],1.1,"+1m19s",cex=1.2,col="white");segments(x[99],1.01,x[99],1.08,lwd=2,col="white")
text(x[197],1.1,"+2m28s",cex=1.2,col="white");segments(x[197],1.01,x[197],1.08,lwd=2,col="white")
text(x[198],1.1,"+3m36s",cex=1.2,col="white");segments(x[198],1.01,x[198],1.08,lwd=2,col="white")


#### General classification after Pyrenees stages (stage 12) ####

## Prepare data
gc<-tdf[,29:40] # Note this changes everyday
colnames(gc)<-1:12
start<-1; last<-12

# Center on median
med<-as.vector(sapply(gc,median,na.rm=TRUE))
gc.m<-sweep(gc,2,med,"-")

## Helper function to draw a line for each rider
Lines <- function(series, col="black", hcol="black", lwd=1, hlwd=2) {
  for (i in 1:length(series[,1])) {
    lines(start:last, series[i,], col=col, lwd=lwd)
  }
} 

## Plot settings 
par(las=1, tck=0.02, mgp=c(2.8,0.3,0.5), cex.lab=1.2,cex.main=2,col.main="white",
    cex.axis=1.2,bg="black",family="serif")

## Yellow jersey
plot(0,xlim=c(start,last),ylim=c(-5310,3960),
     type="n",bty="n",main="General classification after stage 12",xlab="",ylab="",axes=FALSE)
Lines(gc.m,col="white")
axis(1,las=1,at=1:12,tck=0.02,cex.axis=1.5,col="white",col.axis="white",tick=FALSE)

# Some individual riders
lines(start:last,gc.m[28,],col="yellow",lwd=4)     # Froome
lines(start:last,gc.m[19,],col="firebrick3",lwd=4) # Pinot
lines(start:last,gc.m[124,],col="orange",lwd=4)    # Ten Dam

#### Stage results ####

## Prepare data
stage<-tdf[,8:28] # Note this changes everyday
colnames(stage)<-1:21
start<-1; last<-21

# Center on median
med<-as.vector(sapply(stage,median,na.rm=TRUE))
stage.m<-sweep(stage,2,med,"-")

## Plot settings 
par(las=1, tck=0.02, mgp=c(2.8,0.3,0.5), cex.lab=1.2,cex.main=2,col.main="white",
    cex.axis=1.2,bg="black",family="serif")

## Yellow jersey
plot(0,xlim=c(start,last),ylim=c(-2020,1450),
     type="n",bty="n",main="Stage results",xlab="",ylab="",axes=FALSE)
Lines(stage.m,col="white")
axis(1,las=1,at=1:21,tck=0.02,cex.axis=1.5,col="white",col.axis="white",tick=FALSE)

# Some individual riders
lines(start:last,stage.m[28,],col="yellow",lwd=4)     # Froome
lines(start:last,stage.m[43,],col="green",lwd=4)      # Sagan
lines(start:last,stage.m[118,],col="orange",lwd=4)    # Gesink

