#removed all rows prior to 2016
#retitled column headers for readability
#removed three columns regarding dew point
#retitled the three wind columns as they were mislabeled

data <- read.csv('~/Documents/Homeless Deaths Analysis/data/weather_cleaned.csv')
colnames(data)

#to convert wind_high to the proper format (from factor to integer):
data$wind_high <- as.integer(data$wind_high)
data$date <- as.Date(data$date, format = "%m/%d/%Y")
data$temp_avg <- as.integer(data$temp_avg)

#1 and 3. to run summary statistics on the dataset
summary(data)
summary(data$event)

#4 histograms and plots
hist(data$temp_high)
plot(data$date, data$temp_high)

hist(data$temp_low)
plot(data$date, data$temp_low)

hist(data$humidity_avg)
plot(data$date, data$humidity_avg)

hist(data$wind_avg)
plot(data$date, data$wind_avg)

hist(data$precip)
plot(data$date, data$precip)
