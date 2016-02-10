#### Rainfall in the U.K. 1901-2013 ####

## Data
rain<-read.csv("~/Desktop/uk.pre.csv",header=TRUE)

## Calculate monthly anomalies
anom <- function(x) {
    apply(x, 2, function(y) (y - mean(y))/sd(y))
}

dat<-data.frame(anom(rain[,-1]))

## Reshape data to long format
require(reshape)
dat$YEAR<-1901:2013
md<-melt(dat,id="YEAR")
colnames(md)<-c("year","month","precipitation")
md<-md[order(md$year,md$month),]

rain.ts<-ts(md$precipitation,freq=12,start=c(1901,1));plot(rain.ts)

## Find trend in data

# Set parameters
n=length(rain.ts)
t=1:n
k=floor(n/3) # Number of knots

## Fit data using AR1 structure (Can take a while)
# Get trend
rain.gamm=gamm(rain.ts~s(t,k=k,bs="cs"),correlation=corAR1())
rain.trend<-ts(fitted(rain.gamm$lme),frequency=12,start=c(1901,1))

## Plot results
par(mar=c(4,5,2,2),las=1,tck=.02,bty="n",family="serif")
plot(rain.ts,xlab="",ylab="",axes=FALSE,lwd=.75, 
     main="Monthly precipitation anomalies for the U.K. 1901-2013")
lines(rain.trend,col="red",lwd=3)
axis(2,tick=F, las=2)
axis(1,tick=F,at=seq(1900,2015,5))

