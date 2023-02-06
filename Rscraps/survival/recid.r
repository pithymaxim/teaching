library(wooldridge)
library(survival)
library(ggplot2)
library(ggfortify)
data("recid")

# Make the arrested indicator
recid$arrested = 1 - recid$cens

km <- with(recid, Surv(durat, arrested))

km_fit <- survfit(Surv(durat, arrested) ~ 1, data=recid)
summary(km_fit)
plot(km_fit)

### Make the hazard. There is not an immediate way, none of these answers quite do it https://stackoverflow.com/a/67596112/1810279 ###
# First need to convert KM results to dataframe 
df = fortify(km_fit)
# Then the hazard is = [surv(t-1) - surv(t)] / surv(t-1)
# We can implement the lag with vector subsetting:
hazard = ( df$surv[1:length(df$surv)-1] -  df$surv[2:length(df$surv)])/ df$surv[1:length(df$surv)-1]
plot(df$time[-1],hazard, type="l",xlab="Time in months",ylab="Raw hazard")
  

