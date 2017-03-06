### DEATHS
deaths<-read.delim("~/Documents/Homeless Deaths Analysis/data/deaths_jtk_cleaned_geocoded.csv", sep=",")
dim(deaths) # 76
summary(deaths)
deaths["count"]<-1
deaths$month <- months(as.Date(deaths$DOD, "%m/%d/%Y"))
summary(as.factor(deaths$month))
plot(by(deaths$count, deaths$month, sum), xlab="Month", ylab="#Deaths")


### EVICTIONS
evict<-read.delim("~/Documents/Homeless Deaths Analysis/data/evictions_cleaned_geocoded.csv", row.names=NULL)
nrow(evict)
head(evict)
evict["count"]<-1
evict$month <- months(as.Date(evict$SweepDate, "%m/%d/%Y"))
by(evict$count, evict$month, sum)
#summary(as.factor(evict$month))  #code has same effect
plot(by(evict$count, evict$month, sum), xlab="Month", ylab="#Evictions")


