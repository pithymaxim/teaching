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
