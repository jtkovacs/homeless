# Set up environment
setwd("~/Documents/Homeless Deaths Analysis/data/")
library(ggmap)

# Load datasets
food.banks <- read.csv("resources_food_banks_raw.csv")
park.bathrooms <- read.csv("resources_park_bathrooms_cleaned.csv")
public.toilets <- read.csv("resources_public_toilets_raw.csv")
shelters <- read.csv("resources_shelters_cleaned_geocoded.csv")

# Create child datasets
food.banks.simple <- data.frame(food.banks$Longitude, food.banks$Latitude, rep("Food banks", length(food.banks$Longitude)))
colnames(food.banks.simple) <- c("Longitude", "Latitude", "Type")
park.bathrooms.simple <- data.frame(park.bathrooms$xPos, park.bathrooms$yPos, rep("Park bathrooms", length(park.bathrooms$xPos)))
colnames(park.bathrooms.simple) <- c("Longitude", "Latitude", "Type")
public.toilets.simple <- data.frame(public.toilets$Longitude, public.toilets$Latitude, rep("Public toilets", length(public.toilets$Latitude)))
colnames(public.toilets.simple) <- c("Longitude", "Latitude", "Type")
shelters.simple <- data.frame(shelters$Long, shelters$Lat, rep("Shelters", length(shelters$Lat)))
colnames(shelters.simple) <- c("Longitude", "Latitude", "Type")

# Create parent dataset
resources <- rbind(food.banks.simple, park.bathrooms.simple, public.toilets.simple, shelters.simple)

# Map
SeaMap <- get_map(location="Seattle", maptype="toner-lite", zoom=12)
ggmap(SeaMap) + geom_count(aes(Longitude, Latitude, color=Type), data= resources)
    # This message means that some data falls outside the map boundaries:
    # Removed 48 rows containing non-finite values (stat_sum).
