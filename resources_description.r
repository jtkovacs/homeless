### SET UP WORKSPACE
setwd("~/Documents/Homeless Deaths Analysis/data/")


### LOAD DATA
food.banks <- read.csv('resources_food_banks_raw.csv')
park.features <- read.csv('resources_park_features_raw.csv')
public.toilets <- read.csv('resources_public_toilets_raw.csv')
human.services.contracts <- read.csv('resources_human_contracts_raw.csv')


### FOOD BANKS
dim(food.banks)  # 36 rows, 6 columns
head(food.banks)  # City.Feature, Common.Name, Address, Website, Longitude, Latitude
levels(food.banks$City.Feature)  # only one level: "Food Banks"


### PARK FEATURES
dim(park.features)  # 1558 rows, 13 columns
head(park.features)  # PMAID, Name, Alt_Name, xPos(=Long), yPos(=Lat), Feature_ID, hours, Feature_Desc, CHILD_DESC, FIELD_TYPE, YOUTH_ONLY, LIGHTING, Location.1
levels(park.features$Feature_Desc)  # About 68 levels
park.bathrooms <- park.features[park.features$Feature_Desc == c("Restrooms", "Restrooms (ADA Compliant)"),]  # Filter categories of interest
dim(park.bathrooms)  # 68 bathrooms 
colnames(park.bathrooms)
write.csv(park.bathrooms, file = "resources_park_bathrooms_cleaned.csv")  # write out


### PUBLIC TOILETS
dim(public.toilets)  # 5 rows, 6 columns
head(public.toilets)  # City.Feature, Common.Name, Address, Website, Longitude, Latitude
public.toilets %in% park.bathrooms  # Check for any duplication; no dups


### HUMAN SERVICES CONTRACTS
dim(human.services.contracts)  # 256 rows, 3 columns
head(human.services.contracts)  # Human.Services.Department.Division, Agency, Amount
levels(human.services.contracts$Human.Services.Department.Division)  # 7 levels
homeless.services.contracts <- human.services.contracts[human.services.contracts$Human.Services.Department.Division == "Homelessness Intervention & Block Grant Administration ", ]
dim(homeless.services.contracts)  # 56 rows, 3 columns
head(homeless.services.contracts)  # Includes food banks
summary(homeless.services.contracts)
hist(homeless.services.contracts$Amount, breaks=20)
write.csv(homeless.services.contracts, file = "resources_human_contracts_cleaned.csv")  # write out
# this needs to be geocoded


### SHELTERS
# scraped from two websites with shelter_scraper.ipynb
# combined into one dataset, checked manually for duplication
# geocoded with geocoder.ipynb


### MAPPING
# http://www.molecularecologist.com/2012/09/making-maps-with-r/

## Approach #1

library(maps)
library(mapdata)

# Identify spatial extent
min.long <- min(c(food.banks$Longitude, park.bathrooms$xPos, public.toilets$Longitude))  # -122.4153
max.long <- max(c(food.banks$Longitude, park.bathrooms$xPos, public.toilets$Longitude))  # -122.2408
min.lat <- min(c(food.banks$Latitude, park.bathrooms$yPos, public.toilets$Latitude))  # 47.49142
max.lat <- max(c(food.banks$Latitude, park.bathrooms$yPos, public.toilets$Latitude))  # 47.72178

# county.fips
map(database="county", regions = "washington,king")
#map(database="county", regions = "washington")
points(park.bathrooms$xPos, park.bathrooms$yPos, col="blue")
points(public.toilets$Longitude, public.toilets$Latitude, col="red")
points(food.banks$Longitude, food.banks$Latitude, col="green")


## Approach #2

library(RgoogleMaps)

lon <- c(-122.4153,-122.2408) #define our map's ylim
lat <- c(47.491,47.721) #define our map's xlim
center = c(mean(lat), mean(lon))  #tell what point to center on
zoom <- 12  #zoom: 1 = furthest out (entire globe)
terrmap <- GetMap(center=center, zoom=zoom, maptype= "mapmaker-roadmap", destfile = "Seattle.png") 

samps <- park.bathrooms
samps$size <- "small"  #create a column indicating size of marker
samps$col <- "red"   #create a column indicating color of marker
samps$char <- ""   #normal Google Maps pinpoints will be drawn
mymarkers <- cbind.data.frame(samps$xPos, samps$yPos, samps$size, samps$col, samps$char)   
#create the data frame by binding my data columns of GPS coordinates with the newly created columns
names(mymarkers) <- c("lat", "lon", "size", "col", "char")  #assign column headings
Seattle2 <- GetMap.bbox(lonR=range(lon), latR=range(lat), center=center, destfile= "sea2.png", markers= mymarkers, zoom=zoom, maptype="mapmaker-roadmap")
