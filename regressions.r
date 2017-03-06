setwd("~/Documents/Homeless Deaths Analysis/")

plot(windchill.lagged, bool.deaths.lagged)

### WEATHER

weather <- read.csv("data/weather_coded.csv", sep = "\t")
#head(weather)

# add lags
end <- length(weather$death_boolean)
bool.deaths.lagged <- weather$death_boolean[2:end]
precip.lagged <- weather$precip[1:end-1]
bool.precip.lagged <- weather$precip_boolean[1:end-1]
windchill.lagged <- weather$wind_chill[1:end-1]
bool.windchill.lagged <- weather$wind_chill_boolean[1:end-1]

# deaths vs windchill
mod1 <- glm(formula = bool.deaths.lagged ~ bool.windchill.lagged, family = 'binomial')
summary(mod1)  # windchill not statistically significant
exp(mod1$coefficients)  # 1.04101197

# deaths vs windchill and precip
mod2 <- glm(formula = bool.deaths.lagged ~ bool.windchill.lagged + precip.lagged, family = 'binomial')
summary(mod2)  # neither windchill nor precipitation statistically significant
exp(mod2$coefficients)  # windchill: 1.04349475, precip: 1.53534074
plot(mod2$residuals)

# deaths vs precip
mod3 <- glm(formula = bool.deaths.lagged ~ precip.lagged, family = 'binomial')
summary(mod3)  # precip not sig
exp(mod3$coefficients)  # 1.0904790
plot(mod3$residuals)



### EVICTIONS

evictions <- read.csv("data/evictions_cleaned_geocoded.csv", sep = "\t")
head(evictions)

# make Boolean for evictions
all.dates <- seq(as.Date("2016-01-01"), as.Date("2016-12-31"), by="days")
sweep.dates <- as.Date(unique(evictions$SweepDate), format = "%m/%d/%Y")
sweeps.boolean <- as.numeric(all.dates %in% sweep.dates)
bool.sweeps.lagged <- sweeps.boolean[1:end-1]
mod7 <- glm(bool.deaths.lagged ~ bool.sweeps.lagged, family = 'binomial')
summary(mod7)  
plot(mod7$residuals)

