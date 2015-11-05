#### Detrending time-series data #####
## Method using penalised splines
## See for information on method:
## https://ideas.repec.org/p/got/gotcrc/131.html
## http://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.372.6892

setwd("~/Rcode/DetrendTimeSeriesData")

## Libraries
library(nlme)
library(mgcv)

## Load data
gem<-read.csv("gem.csv",header=TRUE, sep=",",row.names=NULL) # Food prices
muv<-read.csv("muv.csv",header=TRUE, sep=",",row.names=NULL) # Deflator

## Adjust data and create year variable
gem$date <- paste0(gem$date, "D01")
gem$date<-as.Date(gem$date, "%YM%mD%d")
gem$year<-format(gem$date,format="%Y")

## Real price series
# Calculate real values:REALPrice=CURRENTPrice/MUV.
# Set 2005 as base year with index value 100
p<-merge(gem,muv) # Merge price series with deflator 
p<-p[order(p$date),]
p$def<-(p$muv/mean(p[p$year==2005,]$muv))
wheat<-log(p$WHEAT_US_HRW / p$def)

## De-trend priceseries:

# Set parameters
n=length(wheat)
t=1:n
k=floor(n/3)

wheat.gamm<-gamm(wheat~s(t,k=k,bs="cs"),correlation=corAR1())
trend<-fitted(wheat.gamm$lme)
dt<-wheat-trend

## Create time series data object
wheat<-ts(data=wheat,frequency=12,start=c(1960,1))
trend<-ts(data=trend,frequency=12,start=c(1960,1))
dt<-ts(data=dt,frequency=12,start=c(1960,1))
dt.p<-window(dt,start=c(1990,1), end=c(2011,12)) 

## Plot
par(mar=c(3,6,3,2),family="serif")
plot(wheat,type="l",lwd=2,xlab="",ylab="",axes=F)
lines(trend,col="red",lwd=2)

# Axis and label
axis(1,at=seq(1960,2015,5),tick=F, cex.axis=1.2)
axis(2,at=seq(-4.5,6.5,.1),las=1,tick=F,cex.axis=1.2)
mtext("Log prices",side=2,line=4,cex=1.2)
text(1962,5.9,label="Wheat prices",cex=1.2);segments(1962,5.85,1964,5.7)
text(1980,5.1,label="Trend in wheat prices",cex=1.2);segments(1980,5.15,1982,5.28)

# Add subplot
par(fig=c(0.5, 0.87,.5,.99), new=T, las=1, ps=9)
plot(dt.p,ylab="Detrended prices",bty="n")

