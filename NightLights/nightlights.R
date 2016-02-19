#==============================================================================
# Script for plotting night lights
# Examples with Egypt and North- and South Korea
# First version: 29-01-2014
# This version:  14-09-2015
#==============================================================================

## Load libraries
library(RCurl)
library(R.utils)
library(rgdal)
library(raster)

## Set parameters for download
url_radianceCalibrated="ftp://ftp.ngdc.noaa.gov/DMSP/web_data/x_rad_cal/rad_cal.tar"
calibratedLights="rad_cal.tar"
hiResTif="world_avg.tif"

## Download and unpack
download.file(url_radianceCalibrated,calibratedLights,mode="wb")
untar(calibratedLights)
gunzip(paste(hiResTif, '.gz', sep=''))

## Create raster
hiResLights=raster("world_avg.tif")       

## Adjust coordinates       
xmax(hiResLights) = 180
ymin(hiResLights) = -90

## Download map for Egypt
egy=getData('GADM', country="EGY", level=0)
       
## Prepate night light data       
e=extent(egy)
r=crop(hiResLights,e)

## Plot data
par(mar=c(3,6,3,6))
colfunc <- colorRampPalette(c("black", "white"))
plot(r,col=colfunc(20))
plot(egy,border="White",add=T)

## Download maps for North- and South-Korea
prk=getData('GADM', country="PRK", level=0)
kor=getData('GADM', country="KOR", level=0)

## Get extent for data
extent(prk)
extent(kor)
e<-extent(122,134,30,44)

## Crop data
r=crop(hiResLights,e)

## Plot
par(mar=c(3,6,3,6))
plot(r,col=grey.colors(30))
plot(kor,border="White",add=T)
plot(prk,border="White",add=T)
