#======================================================================================
# Script for event count within one-degree grid cells
# Using data from UCDP database on conflicts in Africa
# Source: http://www.ucdp.uu.se/ged/data.php
#======================================================================================

## Read the data into a dataframe
ged<-read.csv("ucdp-ged15.csv", header=TRUE, sep=",",row.names=NULL)
ged<-ged[ged$lon >=-180 & ged$lat>= -90,]   # Eliminate coding errors (if any)
ged<-ged[ged$where_prec<=2,] # Keep obs. that can be placed in 1 degree cell 

## Visual inspection of data
require(rworldmap)
map<-getMap(resolution="li")
plot(map,xlim=c(-20,50),ylim=c(-35,40),asp=1)
points(ged$lon,ged$lat,col="red",cex=.6)

## Adjust coordinates for aggregation
ged$X<-floor(ged$lon)
ged$Y<-floor(ged$lat)
ged$Cell<-ged$X+360*ged$Y # Cell identifier

## Count number of observations per cell
counts<-by(ged,ged$Cell,function(d) c(d$X[1], d$Y[1], nrow(d)))
counts.m<-matrix(unlist(counts),nrow=3)
rownames(counts.m)<-c("X","Y","Count")

## Write data to a CSV-file
#write.csv(ged,"africa.csv")
#write.csv(as.data.frame(t(counts.m)),"africa.csv")

## Set colours for different frequencies
count.max <- max(counts.m["Count",])
colours=sapply(counts.m["Count",],function(n) hsv(sqrt(n/count.max),.7,.7,.5))

## Plot the data
par(mar=c(5,4,4,2),family="serif",pty="s")
plot(counts.m["X",]+1/2,counts.m["Y",]+1/2,cex=sqrt(counts.m["Count",]/100),
     pch = 19,col=colours,
     xlab="Longitude of cell center",ylab="Latitude of cell center",
     main="Event counts within one-degree grid cells")
