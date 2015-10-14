#==============================================================================
# Script for aggregation precipitation data from GPCP V2.2
# Data made available in ASCII-format by David Bolvin from NASA GPCP
# Script written by Edwin de Jonge from Statistics Netherlands
# Original files can be found at https://github.com/edwindj/precipitation
# Required shape-files can be found at http://thematicmapping.org/downloads/world_borders.php
# In order to calculate yearly averages at the original grid-resolution
# simply comment out the following line: 
# r.africa <- disaggregate(r.africa, fact=5)
#==============================================================================

## Libraries
library(maptools)
library(raster)
library(sp)

## Create a matrix of years vs months
years <- 1979:2014
months <- sprintf("%02d", 1:12)

m <- t(outer(years, months, paste, sep=""))

## Create matrix of days per month 
days <- matrix( diff(seq(as.Date("1979-01-01"), as.Date("2015-01-01"), by = "month"))
              , nrow=12
              , dimnames=list(months, years))

# No longer needed due to change in GPCP unit of measurement:
#frac <- days / rep(colSums(days), each=12) 

## Create list of files for yearmonth
files <- paste("gpcp_", m, ".ascii", sep="")

## Download data
# Note that you can either use R to download the data, which might take
# some time. Alternatively you can use 'wget' in the terminal:
# wget -c ftp://rsd.gsfc.nasa.gov/pub/912/bolvin/GPCP_ASCII/

DOWNLOADDATA <- readline("Download precipitation data from internet (y/n) ? : ")

if (DOWNLOADDATA=="y"){
  data.url <- "ftp://rsd.gsfc.nasa.gov/pub/912/bolvin/GPCP_ASCII/"
  require(RCurl)
  dir.create("data/NASA", recursive=TRUE)
  for (f in files){
    content <- getBinaryURL(paste(data.url, f, sep=""))
    writeBin(content, paste("data/NASA/", f, sep=""))
    cat("Retrieving ", f, "...\n")
  }
}

## Create a raster
r <- raster(nrows=72, ncols=144, xmn=0, xmx=360, ymn=-90, ymx=90)

dir.create("data/africa",recursive=TRUE)
files.africa <- paste("data/africa/af_", m,".grd", sep="")
files <- paste("data/NASA/", files, sep="")

## Clip raster to include Africa
ext.africa <- extent(c(-26, 64, -47, 38))
for (i in seq_along(files)){
  tab <- read.table(gzfile(files[i]))
  values(r) <- as.matrix(tab)
  # Rotate data and restrict to africa
  r.africa <- crop(rotate(r),ext.africa)
  r.africa <- disaggregate(r.africa, fact=5)
  writeRaster(r.africa, filename=files.africa[i], overwrite=TRUE)
  cat("Writing ", files.africa[i], "...[",i,"/",length(files),"]\n")
}

africa <- brick(stack(files.africa), filename="data/africa.grd", overwrite=TRUE)
africa.u <- mapply(unstack(africa),days, FUN=`*`)
africa.m <- brick(stack(africa.u), filename="data/africa.m.grd", overwrite=TRUE)

## Data per grid cell per year
africa_year <- stackApply( africa.m, indices=col(m), 
                           filename="data/africa_year.grd", overwrite=TRUE
                         , fun = sum)
names(africa_year) <- paste("Y", years, sep="")

## Extract year data per country
country <- readShapePoly("TM_WORLD_BORDERS-0.3/TM_WORLD_BORDERS-0.3.shp")
rcountry <- rasterize(country, africa_year)
cnts <- unique(values(rcountry))[-1]
names(cnts) <- country$NAME[cnts]
cntsCells <- t(sapply( cnts
                   , function(i) {
                       w <- which(rcountry[]==i)
                       m <- extract(africa_year, w)
                       if (is.matrix(m))
                         colMeans(m) 
                       else
                         m
                     }
                   ))

## Write data to file
prec <- as.data.frame(cntsCells)
write.csv(prec, file="data/prec.csv")

