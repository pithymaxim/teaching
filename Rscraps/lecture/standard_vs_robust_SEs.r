library(foreign)
library(stargazer)

auto <- read.dta("http://www.stata-press.com/data/r9/auto.dta")

model = lm(price ~ mpg, data = auto)

se_standard = as.vector(summary(model)$coefficients[,"Std. Error"])
se_robust  = as.vector(coeftest(model,vcov = vcovCL, type="HC1")[,"Std. Error"])

stargazer(model, model, type = "text",
          se = list(se_standard,se_robust))
