### Robust SEs
library(lmtest)
library(sandwich)

# Using coeftest()
mymodel = lm(bwght ~ male, data=bwght)
coeftest(mymodel, vcov = vcovHC(mymodel, type="HC1"))

# Using lm_robust()
library(estimatr)
lm_robust(mpg ~ disp, data=mtcars, se_type="HC1")
