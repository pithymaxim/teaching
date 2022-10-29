library(wooldridge)
library(survival)
library(ggplot2)
library(ggfortify)
data("recid")
recid$arrested = 1 - recid$cens
recid$durat = recid$durat / 12

km <- with(recid, Surv(durat, arrested))

km_fit <- survfit(Surv(durat, arrested) ~ 1, data=recid)
summary(km_fit, times =seq(0,60,12) )
autoplot(km_fit,)
