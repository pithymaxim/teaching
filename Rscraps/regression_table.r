library(foreign)
library(stargazer)
auto <- read.dta("http://www.stata-press.com/data/r9/auto.dta")
###################################
# Cannot use lm_robust arguments but starprep() option is great
# https://declaredesign.org/r/estimatr/articles/regression-tables.html

# Regression table 
mod1 = lm(price ~ mpg                          , data=auto,se_type="stata")
mod2 = lm(price ~ mpg + trunk                  , data=auto)
mod3 = lm(price ~ mpg + trunk + factor(foreign), data=auto)

stargazer(mod1,mod2,mod3, type = "html",  #we use html output to match our planned R Markdown output
          title = "My price models", out = "test.html", 
          dep.var.labels = "Price", omit.stat = c("f","ser","adj.rsq"),
          add.lines = list(c("Outcome mean",777,888,999)),
          omit = c("Constant"),
          covariate.labels = c("Miles per Gallon","Trunk","Foreign"),
          se=starprep(mod1, mod2, mod3, clusters = auto$foreign, se_type = "stata"))
######################################
