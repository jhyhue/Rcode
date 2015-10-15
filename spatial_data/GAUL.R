#### GAUL data: subset ####
## Subset GAUL dataset to administrative divisions of countries of interest.
## Reference year is 2014
## For data source see: 
## https://github.com/akvo/akvo-core-services/tree/master/akvo-geo/doc

setwd("~/dataRe/GAUL") 
gc() # Garbage collection

## Libraries
library(countrycode)
library(rgdal)

## Data
countrycode<-na.omit(countrycode_data)
gaul<-readOGR(dsn="g2015_2014_1",layer="g2015_2014_1",dropNULLGeometries=TRUE) # Big file    

## Country codes for region of interest: Africa in this case
# Need to add Western Sahara
ccode<-c(countrycode[countrycode$continent=="Africa",]$iso3c,"ESH")

## Create ISO3C countrycode variable in GAUL dataset, subset data
gaul$ccode<-countrycode(gaul$ADM0_NAME,"country.name","iso3c",warn=TRUE)
adm1.Africa<-gaul[gaul$ccode %in% ccode,]

## Save data
save(list="adm1.Africa",file="GAUL_Africa_ADM1.Rdata")
