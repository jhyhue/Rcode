#### Plotting earthquake locations in the past 7 days ####
# Crappier version of http://earthquake.usgs.gov/earthquakes/map/

## Libraries
library(ggplot2)

## Load base world map
mp<-NULL
W<-borders("world", colour="gray50", fill="gray50") 
mp<-ggplot()+W

## Add data on earthquakes in the last 7 days
Q<-read.csv("http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_week.csv",
            header=TRUE,sep=",",row.names=NULL)

quake_map<-mp+geom_point(aes(x=longitude,y=latitude,size=mag),data=Q,alpha=.5,
                  col="firebrick3")
plot(quake_map)
