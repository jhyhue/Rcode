## Fitting data with penalised splines

## Libraries
library(mgcv)
library(reshape)

#### Trending data: Quarterly GDP data 1959-2009 (Stock & Watson, 2010) ####

# Load data and set parameter
data<-scan("GDP.txt")

n=length(data)
t=1:n
k=floor(n/3) # Number of knots

# Fit data using AR1 structure
data.gamm=gamm(data~s(t,k=k,bs="cs"),correlation=corAR1())

# Create time series
gdp<-ts(data,frequency=4,start=c(1959,1))
gdp.trend<-ts(fitted(data.gamm$lme),frequency=4,start=c(1959,1))
gdp.dt<-ts(gdp-gdp.trend,frequency=4,start=c(1959,1))

# Plot results
par(mfrow=c(2,1),mar=c(4,6,2,6),las=1,tck=.02,bty="n")
plot(gdp,xlab="time",ylab="GDP",type="p",pch=1,cex=.75)
lines(gdp.trend,col="red",lwd=3)
plot(gdp.dt,type="l",xlab="time",ylab="Detrended values")

#### Seasonal data: Monthly temperature for Guatemala 1901-2013 (CRU) ####

# Load data
gtm<-read.csv("TemperatureGuatemala_1901-2013.csv",header=TRUE,sep=",")

# Reshape data
d<-melt(gtm,id="YEAR")
colnames(d)<-c("year","month","temperature")
d<-d[order(d$year,d$month),]

data<-d$temperature

# Set parameters
n=length(data)
t=1:n
k=floor(n/3) # Number of knots

# Fit data using AR1 structure (Can take a while)
data.gamm=gamm(data~s(t,k=k,bs="cs"),correlation=corAR1())

# Create time series
temp<-ts(data,freq=12,start=c(1901,1))
temp.trend<-ts(fitted(data.gamm$lme),frequency=12,start=c(1901,1))
temp.dt<-ts(temp-temp.trend,frequency=12,start=c(1901,1))

# Plot results
par(mfrow=c(2,1),mar=c(4,6,2,6),las=1,tck=.02,bty="n")
plot(temp,xlab="time",ylab="Temperature",type="p",pch=1,cex=.75)
lines(temp.trend,col="red",lwd=3)
plot(temp.dt,type="l",xlab="time",ylab="Monthly anomalies")
