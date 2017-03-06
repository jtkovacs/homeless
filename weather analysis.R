library(xlsx)
deaths <- read.xlsx('deaths_final.xlsx', 1)
weather <- read.csv('Weather - cleaned.csv')

#to convert date to the proper format:
weather$date <- as.Date(weather$date, format = "%m/%d/%Y")

#to convert temperature to the proper format (from factor to integer):
weather$temp_avg <- as.integer(weather$temp_avg)

#to calculate wind chill (got the formula by Googling):
weather$wind_chill <- (35.74 + (.6215 * weather$temp_low) - (35.75 * (weather$wind_avg ^ .16)) + ((.4275 * weather$temp_low) * (weather$wind_avg ^ .16)))

#to convert the calculated wind chill to a boolean using our threshold of 32 degrees (not sure if using right term - but basically setting the value to 0/1 or TRUE/FALSE) value
weather$wind_chill_boolean <- ifelse(weather$wind_chill <= 32, 1, 0)

#to update the DOD column in the deaths dataframe to Date
deaths$date <- deaths$DOD

#to join the deaths and weather data frames
library(dplyr)
deaths_and_weather <- join(weather, deaths, match = 'first')

#to update deaths$date to either be value of 0 or 1 depending on whether there was a death on that day


#to lag deaths against wind chill and precipitation









#got stuck here manipulating data in r so I added the boolean indicators for death via Excel and lagged the deaths data by one day:
data <- read.xlsx('weather and deaths - manual.xlsx', 1)

#calculate logistic regression

#just wind chill
model <- glm(formula = death_boolean ~ wind_chill_boolean, data = data, family = 'binomial')
#wind chill and precipitation
model <- glm(formula = death_boolean ~ wind_chill_boolean + precip, data = data, family = 'binomial')



#after speaking to Chris, he wanted me to create a new variable to encapsulate whether the temperature was cold enough and it was wet enough out
#this variable would be our extreme weather variable with a value of either 1 or 0
#I did some Googling and was not able to find a good indicator of what would qualify as a lot of rain in a given day so...
#after setting the amount of precipitation in a day to both .5" and .25", it would leave us with only three and 10 days, 
#respectively, throughout the year where we would have 'extreme weather' and thus with such a small dataset, I did not further try to explore the model

