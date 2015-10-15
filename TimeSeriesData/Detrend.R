#### Detrending time-series data #####
## Method using penalised splines
## See for information on method:
## https://ideas.repec.org/p/got/gotcrc/131.html
## http://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.372.6892

## Libraries
library(mgcv)
library(reshape)

## Start with trending data example
##  Quarterly GDP data 1959-2009 from Stock & Watson (2010)
dat<-scan("GDP.txt");plot(dat)
gdp<-ts(dat,frequency=4,start=c(1959,1))

## Set parameters
n=length(dat)
t=1:n
k=floor(n/3) # Number of knots

## Fit data using AR1 structure
d.gamm=gamm(dat~s(t,k=k,bs="cs"),correlation=corAR1())

## Subtract trend from time-series
gdp.trend<-ts(fitted(d.gamm$lme),frequency=4,start=c(1959,1))
gdp.dt<-ts(gdp-gdp.trend,frequency=4,start=c(1959,1)) # Detrended data

## Plot results
par(mfrow=c(2,1),mar=c(4,5,2,2),las=1,tck=.02,bty="n",family="serif")

# Upper panel: original data
plot(gdp,xlab="",ylab="GDP",type="p",pch=1,cex=.75,axes=FALSE)
lines(gdp.trend,col="red",lwd=3)
axis(2,tick=F, las=2)

# Lower panel: detrended data
plot(gdp.dt,type="l",xlab="",ylab="Detrended values",axes=FALSE)
axis(1,tick=F); axis(2,tick=F, las=2)

## Example with seasonal data 
## Monthly temperature data for Guatemala 1901-2013 (CRU) 
gtm<-read.csv("GTMTemp1901-2013.csv",header=TRUE,sep=",")
tmp<-ts(data,freq=12,start=c(1901,1))

## Reshape data to long
d<-melt(gtm,id="YEAR")
colnames(d)<-c("year","month","temperature")
d<-d[order(d$year,d$month),]
dat<-d$temperature

## Set parameters
n=length(dat)
t=1:n
k=floor(n/3) # Number of knots

## Fit data using AR1 structure (Can take a while)
d.gamm=gamm(dat~s(t,k=k,bs="cs"),correlation=corAR1())

## Subtract trend from time-series
# This basically creates anomalies
tmp.trend<-ts(fitted(d.gamm$lme),frequency=12,start=c(1901,1))
tmp.dt<-ts(tmp-tmp.trend,frequency=12,start=c(1901,1))

## Plot results
par(mfrow=c(2,1),mar=c(4,5,2,2),las=1,tck=.02,bty="n",family="serif")
# Upper panel: original data
plot(tmp,xlab="",ylab="Temperature",type="p",pch=1,cex=.75,axes=FALSE)
lines(tmp.trend,col="red",lwd=3)
axis(2,tick=F, las=2)

# Lower panel: detrended data
plot(tmp.dt,type="l",xlab="",ylab="Monthly anomalies",axes=FALSE)
axis(1,tick=F);axis(2,tick=F, las=2)
