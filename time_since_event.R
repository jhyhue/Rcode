#### Event time dependence ####
# Example for calculating time since and time to event
# Method taken: http://stackoverflow.com/questions/16488100

## Create mock data:
set.seed(42);e<-rbinom(90,1,.2) # Some outcome event
df<-data.frame(country=c( rep("San Monique",30),rep("Isthmus",30),rep("Nambutu",30)),
               ccode=as.numeric(factor(country)),
               year=c(rep(1985:2014,3)),event=e)
df<-df[order(df$ccode,df$year),]

## Using data.table
require(data.table)
DT <- data.table(df)

DT[, c("TimeSinceLastEvent", "CurrentStreak","TimeToNextEvent") := {
  rr <- sequence(rle(!event)$lengths)
  rr2 <- sequence(rle(event)$lengths)
  list(rr * !event, rr * event, rr2*!event)},by=ccode ]