### Load packages #########
library(lmtest)
library(sandwich)
library(wooldridge)
library(stargazer)
###########################

# Load data 
data("crime1")

# Run regression
mymodel = lm(narr86 ~ inc86, data=crime1)
# Make robust standard errors 
robust_SEs = as.vector(coeftest(mymodel, vcov = vcovHC(mymodel, type="HC1"))[,"Std. Error"])
# Show in table
stargazer(mymodel,se=list(robust_SEs), type="text")
