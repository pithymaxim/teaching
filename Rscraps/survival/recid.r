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

#### Plot hazards (recid data) https://stackoverflow.com/a/67596112/1810279
# Example of decreasing hazard (decreasing chance of arrest)
library(bshazard)
bs_fit <- bshazard(Surv(durat, arrested) ~ 1, data=recid)
plot(bs_fit)

#### Plot hazards (cancer data). 
# Example of increasing hazard (increasing chance of death)
library(foreign)
library(bshazard)
cancer = read.dta("http://www.stata-press.com/data/r9/cancer.dta")
bs_fit <- bshazard(Surv(studytime , died) ~ 1, data=cancer, alpha=1)
plot(bs_fit, conf.int= FALSE)

# To show raw hazard:
df = fortify(km_fit)
# Then the hazard is = [surv(t-1) - surv(t)] / surv(t-1)
# We can implement the lag with vector subsetting:
hazard = ( df$surv[1:length(df$surv)-1] -  df$surv[2:length(df$surv)])/ df$surv[1:length(df$surv)-1]
plot(df$time[-1],hazard, type="l",xlab="Time in months",ylab="Raw hazard")
  

