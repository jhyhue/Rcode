# Working with satellite night light data

**Update**: `AggNightLights.R` is a more comprehensive code for `R` that processes the [night light data](http://ngdc.noaa.gov/eog/dmsp/downloadV4composites.html) and aggregates night light density to, in this case, state level in Nigeria. 

This is a short try out for working with satellite night light data using Egypt and the Koreas as examples. The code is largely based on [this post](http://jeffreybreen.wordpress.com/2010/10/22/incremental-improvements-to-nightlights-mapping-thanks-to-r-bloggers/)


### Load libraries
```R
library(RCurl)
library(R.utils)
library(rgdal)
library(raster)
```

### Set parameters for download
```R
url_radianceCalibrated="ftp://ftp.ngdc.noaa.gov/DMSP/web_data/x_rad_cal/rad_cal.tar"
calibratedLights="rad_cal.tar"
hiResTif="world_avg.tif"
```

### Download and unpack
```R
download.file(url_radianceCalibrated,calibratedLights,mode="wb")
untar(calibratedLights)
gunzip(paste(hiResTif, '.gz', sep=''))
```

### Create raster
```R
hiResLights=raster("world_avg.tif")       
```

### Adjust coordinates       
```R
xmax(hiResLights) = 180
ymin(hiResLights) = -90
```

## Example 1: Egypt
For the first example we will look at human activity around the Nile in Egypt

### Download map for Egypt
```R 
egy=getData('GADM', country="EGY", level=0)
```

### Prepate night light data       
```R
e=extent(egy)
r=crop(hiResLights,e)
```

### Plot data
```R
par(mar=c(3,6,3,6))
colfunc <- colorRampPalette(c("black", "white"))
plot(r,col=colfunc(20))
plot(egy,border="White",add=T)
```

The resulting plot (shown below) illustrates how human activity in Egypt is centered around the Nile as it has been for centuries.
In the upper right corner of the figure we also detect the night light emissions on Israel.
Note there there is a bit of a mismatch between the map and the data overlay which is due to the geocoding of the coastal boundaries. I haven't addressed this issue in this example .

![](http://i.imgur.com/ZsIDxpH.png)


## Example 2: the Koreas
For the second example we look at the difference in night light emissions between North and South Korea. 
Night light emissions are maybe the ultimate form of conspicuous consumption and are therefore a useful proxy for economic activity which can supplement, or even substitute, statistical data on economic activity as is done in the recent literature (for instance in [Henderson et al. 2012](http://www.econ.brown.edu/faculty/David_Weil/Henderson%20Storeygard%20Weil%20AER%20April%202012.pdf) or [Michalopoulos and Papaioannou,2014](http://qje.oxfordjournals.org/content/129/1/151.abstract))
We use the satellite data to see the difference in economic activity between North and South Korea

### Download maps for North- and South-Korea
```R
prk=getData('GADM', country="PRK", level=0)
kor=getData('GADM', country="KOR", level=0)
```

### Get extent for data
```R
extent(prk)
extent(kor)
e<-extent(122,134,30,44)
```

### Crop data
```R
r=crop(hiResLights,e)
```

### Plot
```R
par(mar=c(3,6,3,6))
plot(r,col=grey.colors(30))
plot(kor,border="White",add=T)
plot(prk,border="White",add=T)
```

The resulting plot is shown below which illustrates a striking difference in economic activity between the two countries with the wealthier sout lighting up at night whereas the North is pitch dark. Note again that there is some noise in the picture on the South-East tip of South Korea which I haven't addressed properly yet. 

![](http://i.imgur.com/0vsJnHb.png)



