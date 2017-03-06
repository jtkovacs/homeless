### SET UP ENVIRONMENT
setwd('~/Documents/Homeless Deaths Analysis/')
library(spatstat) # spatial analysis of points data; R 3.2.3
library(spdep) # for hotspot w/ Getis-Ord Gi; R 3.3.2
library(ape) # for Moran's i; R 3.3.2  
library(sp) # create spatial datatypes; R 3.3.2
library(DCluster) # for cluster analysis; R 3.3.2


### LOAD DATA
shelters <- read.csv('data/resources_shelters_cleaned_geocoded.csv')
evictions <- read.csv('data/evictions_cleaned_geocoded.csv', sep='\t')
deaths <- read.csv('data/deaths_cleaned_geocoded.csv', sep='\t') 
proximities <- read.csv('data/proximity_counts.csv', sep='\t')
# In Excel, removed death on Forest Service Road at (47.9627671, -122.9103181)


### CONVERT TO SPATIAL FORMATS w/ spatstat
# Get boundaries
#min.long <- min(min(shelters$Long), min(evictions$Long), min(deaths$Long))
#max.long <- max(max(shelters$Long), max(evictions$Long), max(deaths$Long))
#min.lat <- min(min(shelters$Lat), min(evictions$Lat), min(deaths$Lat))
#max.lat <- max(max(shelters$Lat), max(evictions$Lat), max(deaths$Lat))
# These give a better map resolution because the extent of shelters and deaths 
# are so much larger than the borders of Seattle:
min.long <- min(evictions$Long)
max.long <- max(evictions$Long)
min.lat <- min(evictions$Lat)
max.lat <- max(evictions$Lat)
# In general: ppp(x.coordinates, y.coordinates, x.range, y.range)
shelters.ppp <- ppp(shelters$Long, shelters$Lat, c(min.long, max.long), c(min.lat, max.lat))
evictions.ppp <- ppp(evictions$Long, evictions$Lat, c(min.long, max.long), c(min.lat, max.lat)) 
deaths.ppp <- ppp(deaths$Long, deaths$Lat, c(min.long, max.long), c(min.lat, max.lat))


### DISPLAY w/ spatstat
# Points
# as.ppp() trims display to proper extent
plot(as.ppp(shelters.ppp))
plot(evictions.ppp)
plot(as.ppp(deaths.ppp))
# Density (heat map)
plot(density(deaths.ppp, adjust=.25))
plot(density(evictions.ppp, adjust=.25))
plot(density(shelters.ppp, adjust=.25))
# Nearest neighbor cleaning
plot(nnclean(shelters.ppp, k = 1), chars = c(".", "*"))
# Data sharpening
plot(sharpen(shelters.ppp, sigma=0.5, edgecorrect = TRUE))
# Contour
contour(density(shelters.ppp), axes=F)
contour(density(evictions.ppp), axes=F)
contour(density(deaths.ppp), axes=F)
# 3D
persp(density(shelters.ppp))
persp(density(evictions.ppp))
persp(density(deaths.ppp))


# EXPLORE RANDOMNESS w/ spatstat
# This is Ripley's K-function: plots theoretical random vs. empirical process
# "summary test of whether the data are randomly distributed"
# iso=observed, pois=expected if random
plot(Kest(shelters.ppp))
plot(Kest((evictions.ppp)))
plot(Kest(deaths.ppp))
# Plot w/ envelope (from multiple simulations)
plot(envelope(shelters.ppp, Kest, nsim=50))
# G function: "a useful statistic summarising one aspect of the “clustering” of points"
shelters.Gest <- Gest(shelters.ppp)
plot(shelters.Gest)

# CREATE NEAREST NEIGHBORS LIST w/ spatstat
shelters.nni <- nndist(shelters$Long, shelters$Lat)

# CALCULATE MORAN'S I w/ ape
# Checks whether there is spatial autocorrelation in a variable
# Maybe I can count #deaths per point and use that as the variable? but it's very unlikely to be >1
# create inverse distance matrix
# https://cran.r-project.org/web/packages/ape/vignettes/MoranI.pdf
# http://rspatial.org/analysis/rst/3-spauto.html
# http://resources.esri.com/help/9.3/arcgisengine/java/gp_toolref/spatial_statistics_tools/how_spatial_autocorrelation_colon_moran_s_i_spatial_statistics_works.htm 
death.dists <- as.matrix(dist(cbind(proximities$lon, proximities$lat)))
death.dists.inv <- 1/death.dists  
death.dists.inv[is.infinite(death.dists.inv)] <- 0
diag(death.dists.inv) <- 0
Moran.I(proximities$ShelterCount, death.dists.inv)
Moran.I(proximities$SweepCount, death.dists.inv)

# CALCULATE MORAN's I w/ spdep
#moran.test(outcome, listw = nb2listw(neighbor.list))


### TEST ASSOCIATIONS BETWEEN CLUSTERS
