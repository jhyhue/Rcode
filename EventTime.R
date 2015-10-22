#### Event time dependence ####
## Example for calculating time since and time to event
## Using method taken from here:
# http://stackoverflow.com/questions/16488100/using-r-to-count-a-run-since-last-event-in-panel-data

set.seed(42)

## Create mock data:

# Time-series cross-section stuff
country<-c( rep("San Monique",30),rep("Isthmus",30),rep("Nambutu",30))
ccode<-as.numeric(factor(country))
year<-c(rep(1985:2014,3))
# Some outcome event
set.seed(42);e<-rbinom(90,1,.2)

df<-data.frame(country=country,ccode=ccode,year=year,event=e)
df<-df[order(df$ccode,df$year),]

## Using data.table
require(data.table)
DT <- data.table(df)

DT[, c("TimeSinceLastEvent", "CurrentStreak","TimeToNextEvent") := {
  rr <- sequence(rle(!event)$lengths)
  rr2 <- sequence(rle(event)$lengths)
  list(rr * !event, rr * event, rr2*!event)},by=ccode ]

