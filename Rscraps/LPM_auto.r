library(foreign)
library(lmtest)
library(sandwich)
options(scipen=999) # turn off scientific notation 

# Load auto data 
auto <- read.dta("http://www.stata-press.com/data/r9/auto.dta")

# Make foreign dummy (loads as factor which doesn't work in reg)
auto$foreign.dummy = ifelse(auto$foreign=="Foreign",1,0)

# Estimate model 
mymodel = lm(foreign.dummy ~ mpg + price, data=auto)

# Make the SEs robust 
coeftest(mymodel, vcov = vcovHC(mymodel, type="HC1"))

# # Output
# > coeftest(mymodel, vcov = vcovHC(mymodel, type="HC1"))

# t test of coefficients:

#                 Estimate   Std. Error t value    Pr(>|t|)    
# (Intercept) -0.893459808  0.247015276 -3.6170    0.000554 ***
# mpg          0.042422693  0.008512812  4.9834 0.000004247 ***
# price        0.000046595  0.000021171  2.2009    0.030996 *  
