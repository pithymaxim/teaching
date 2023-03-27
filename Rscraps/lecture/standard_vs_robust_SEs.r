library(foreign)
library(stargazer)

auto <- read.dta("http://www.stata-press.com/data/r9/auto.dta")

# Estimate model
model = lm(price ~ mpg, data = auto)

# Calculate the robust standard errors
se_robust  = as.vector(coeftest(model,vcov = vcovCL, type="HC1")[,"Std. Error"])

# Show both in a table
stargazer(model, model, type = "text",
          se = list(NULL,se_robust))
