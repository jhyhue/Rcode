#### GAUL data: subset ####
# Subset GAUL dataset to administrative divisions of countries of interest.
# Reference year: 2014
# Data source:
# https://github.com/akvo/akvo-core-services/tree/master/akvo-geo/doc
setwd("~/GAUL") 
gc() # Garbage collection

## Libraries
library(countrycode)
library(rgdal)

## Data
countrycode<-na.omit(countrycode_data)
gaul<-readOGR(dsn="g2015_2014_0",layer="g2015_2014_0",dropNULLGeometries=TRUE) # Large file    

## Country codes for region of interest: Africa in this case
# Need to add Western Sahara
ccode<-c(countrycode[countrycode$continent=="Africa",]$iso3c,"ESH")

## Create ISO3C countrycode variable in GAUL dataset, subset data
gaul$ccode<-countrycode(gaul$ADM0_NAME,"country.name","iso3c",warn=TRUE)
adm0.Africa<-gaul[gaul$ccode %in% ccode,]

## Save data
saveRDS(adm0.Africa,file="ADM0AfricaGAUL.rds")