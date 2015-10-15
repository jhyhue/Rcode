#### Satellite night lights data ####
## Calculating night light density, aggregating from the pixel level. 
## Example for Nigeria


#### LOAD ####
Dir<-"~/[SPECIFY DIR]/TIF" # Specify directory with TIF-files

## Libraries
library(sp)
library(maptools)
library(raster)
library(reshape)
library(rgdal)

## Data
# Shapfile from http://gadm.org/download
shp<-readRDS("~/[SPECIFY DIR]/NGA_adm2.rds")
#plot(shp)

# TIF files
tif<-list.files(Dir,full.names=T)
dat<-lapply(tif,raster)

## Vectors for the for-loop
N<-length(dat)
raster<-list()
sat<-list()
sat.mean<-list()

#### CLEAN ####
## For loop can take a while, due to step (3)

for(i in 1:N){

  # 1) Assign same projection as shape file with boundaries
  proj4string(dat[[i]])<-proj4string(shp)  
  
  # 2) Crop the rasters
  raster[[i]]=crop(dat[[i]],extent(shp))   
  
  # 3) Extract the data and calculate the average per district
  sat[[i]]<-extract(raster[[i]],shp) 
  sat.mean[[i]]<-unlist(lapply(sat[[i]],function(x) if (!is.null(x)) 
                mean(x,na.rm=TRUE) else NA )) 
}

## Append data to shapefile
names(sat.mean)<-1992:2010
shp@data<-data.frame(shp@data,data.frame(sat.mean))
                     
## Reshape dataframe from wide to long
nlight<-data.frame(shp[,c(6,11:29)])
nlight<-melt(nlight,id="NAME_1")
nlight$variable<-rep(1992:2010,each=length(shp))
colnames(nlight)<-c("state","year","nlight")
nlight<-nlight[order(nlight$state,nlight$year),]

# Save data 
write.csv(nlight,file="NightLightsNGA.csv")

## Figure
colfunc <- colorRampPalette(c("black", "white"))
par(mar=c(2,2,2,2),family="serif",mfrow=c(1,2))
plot(raster[[1]],col=colfunc(20),axes=FALSE,box=FALSE,main="1992") 
plot(shp,border="White",add=T)
plot(raster[[19]],col=colfunc(20),axes=FALSE,box=FALSE,main="2010") 
plot(shp,border="White",add=T)
