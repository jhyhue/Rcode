#======================================
# Calculating spatial lag
# for time-series cross-section data
#======================================

## Create observations (points)
require(sp)
pts<-cbind(set.seed(2014),x=runif(30,1,5),y=runif(30,1,5),
       time=sample(1:5,30,replace=T))
pts<-SpatialPoints(pts)

## Observations take place in different areas; create polygons for areas
X<-c(rep(1,5),rep(2,5),rep(3,5),rep(4,5),rep(5,5)) 
Y<-c(rep(seq(1,5,1),5))
df<-data.frame(X,Y)
df$cell<-1:nrow(df) # Grid-cell identifier

require(raster)
coordinates(df)<-~X+Y 
rast<-raster(extent(df),ncol=5,nrow=5)
grid<-rasterize(df,rast,df$cell,FUN=max)
grid<-rasterToPolygons(grid) # Create polygons 

## Visualise
plot(grid);points(pts)

## Create data frame
grid$cc<-1:nrow(grid) # Units
tiempo<-1:5           # Time
polygon<-as.vector(unique(unlist(grid$cc,use.names=FALSE)))

# Loop to create panel data frame
timeCol<-rep(tiempo,length(polygon))
timeCol<-timeCol[order(timeCol)]

polCol <- character()
for(i in tiempo){
  row <- polygon
  polCol <- c(polCol, row)
}

df<-data.frame(time=timeCol,nrow=polCol)
df$nrow<-as.numeric(df$nrow)
df<-df[order(df$time,df$nrow),] # Order data frame 

## Match points with corresponding polygon
pts<-SpatialPointsDataFrame(pts,data.frame(pts$time)) # This is a bit clumsy
pts$nrow=over(SpatialPoints(pts),SpatialPolygons(grid@polygons),
              returnlist=TRUE) 

## Aggregate the data per polygon
pts$level<-1
pts.a<-aggregate(level~nrow+time,pts,FUN=sum) # No NA's

## Merge the data
df2<-merge(df,pts.a,all.x=T)
df2[is.na(df2$level),]$level<-0 # Set NA's to 0

## Create contiguity matrix
require(spdep)
k<-poly2nb(grid,queen=TRUE) # Create neighbour list
W<-nb2listw(k,style="B",zero.policy=TRUE) # Spatial weights; binary
con<-as.matrix(listw2mat(W)) # Contiguity matrix

## Calculate spatial lag using Kronecker product
N<-length(as.vector(unique(df2$nrow)))
T<-length(as.vector(unique(df2$time)))
ident<-diag(1,nrow=T)
df2$SpatLag<-(ident%x%con)%*%df2$level
