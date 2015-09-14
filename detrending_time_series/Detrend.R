#==============================================================================
# Detrending time-series data using penalised splines
#==============================================================================

## Libraries
library(mgcv)
library(reshape)

#======================================
#### Trending data #### 
# Quarterly GDP data 1959-2009 
# (Stock & Watson, 2010) 
#======================================

## Load data and set parameters
data<-scan("GDP.txt")

n=length(data)
t=1:n
k=floor(n/3) # Number of knots

## Fit data using AR1 structure
data.gamm=gamm(data~s(t,k=k,bs="cs"),correlation=corAR1())

# Create time series
gdp<-ts(data,frequency=4,start=c(1959,1))
gdp.trend<-ts(fitted(data.gamm$lme),frequency=4,start=c(1959,1))
gdp.dt<-ts(gdp-gdp.trend,frequency=4,start=c(1959,1)) # Detrended data

# Plot results
par(mfrow=c(2,1),mar=c(4,5,2,2),las=1,tck=.02,bty="n",family="serif")

# Upper panel: original data
plot(gdp,xlab="",ylab="GDP",type="p",pch=1,cex=.75,axes=FALSE)
lines(gdp.trend,col="red",lwd=3)
axis(1,tick=F)
axis(2,tick=F, las=2)

# Lower panel: detrended data
plot(gdp.dt,type="l",xlab="",ylab="Detrended values",axes=FALSE)
axis(1,tick=F)
axis(2,tick=F, las=2)

#======================================
#### Seasonal data #### 
# Monthly temperature  data 
# Guatemala 1901-2013 (CRU) 
#======================================

## Load data
gtm<-read.csv("TemperatureGuatemala_1901-2013.csv",header=TRUE,sep=",")

## Reshape data to long
d<-melt(gtm,id="YEAR")
colnames(d)<-c("year","month","temperature")
d<-d[order(d$year,d$month),]

data<-d$temperature

## Set parameters
n=length(data)
t=1:n
k=floor(n/3) # Number of knots

## Fit data using AR1 structure (Can take a while)
data.gamm=gamm(data~s(t,k=k,bs="cs"),correlation=corAR1())

## Create time series
temp<-ts(data,freq=12,start=c(1901,1))
temp.trend<-ts(fitted(data.gamm$lme),frequency=12,start=c(1901,1))
temp.dt<-ts(temp-temp.trend,frequency=12,start=c(1901,1)) # Detrended data

## Plot results
par(mfrow=c(2,1),mar=c(4,5,2,2),las=1,tck=.02,bty="n",family="serif")

# Upper panel: original data
plot(temp,xlab="",ylab="Temperature",type="p",pch=1,cex=.75,axes=FALSE)
lines(temp.trend,col="red",lwd=3)
axis(1,tick=F)
axis(2,tick=F, las=2)

# Lower pannel: detrended data
plot(temp.dt,type="l",xlab="",ylab="Monthly anomalies",axes=FALSE)
axis(1,tick=F)
axis(2,tick=F, las=2)
