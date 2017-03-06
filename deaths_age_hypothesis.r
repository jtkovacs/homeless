setwd("~/Documents/Homeless Deaths Analysis/data/")

deaths <- read.csv("deaths_cleaned_geocoded.csv", sep="\t")
homeless.mean <- mean(deaths$age)
regional.mean <- 72.4 # http://www.kingcounty.gov/depts/health/data/community-health-indicators.aspx
t.test(deaths$age, alternative="two.sided", mu=72.4, conf.level = 0.95)
