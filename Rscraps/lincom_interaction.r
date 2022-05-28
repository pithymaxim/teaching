library(foreign)
library(multcomp) # for glht (https://www.rdocumentation.org/packages/multcomp/versions/1.4-19/topics/glht)
library(estimatr) # for lm_robust

# Load data 
nl = read.dta("http://www.stata-press.com/data/r8/nlsw88.dta")
# Run model with robust SEs
model = lm_robust(wage ~ factor(race) + factor(south)
           + tenure + married*collgrad, data=nl, se_type="stata")
summary(model)
# Show names
names(coef(model))
# Need backticks to have spaces in the coefficient names 
summary(glht(model,
           linfct=c("`collgradcollege grad` + `marriedmarried:collgradcollege grad` = 0")))
