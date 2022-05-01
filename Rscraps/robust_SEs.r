### Robust SEs
library(lmtest)
library(sandwich)
mymodel = lm(bwght ~ male, data=bwght)
coeftest(mymodel, vcov = vcovHC(mymodel, type="HC1"))
