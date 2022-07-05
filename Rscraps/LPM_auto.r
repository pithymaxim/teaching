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
