# This code makes the HTML table here: https://htmlpreview.github.io/?https://github.com/pithymaxim/teaching/blob/main/Rscraps/reg_table_test.html
# Wanted a regression table where:
# (i) outcome means are reported in the table
# (ii) N changes across columns 
# (iii) columns have different standard error adjustments, including clusters

# The "se" option in stargazer() takes a list of vectors, where entry i
# gives the standard errors for column i. The coeftest() lines 
# calculate these standard errors.

# Notes:
# --This option works in stargazer <<if>> N does not change across colums:
#      se=starprep(mod1, mod2, mod3, clusters = auto$foreign, se_type = "stata")
# --lm_robust() does not work with stargazer (https://stackoverflow.com/questions/59224229/why-does-stargazer-give-me-a-table-of-output-for-my-lm-regression-output-but-not)
# --Example of using coeftest to adjust standard errors: https://evalf21.classes.andrewheiss.com/example/standard-errors/
#########################################################
library(foreign)
library(stargazer)
library(tidyverse) # Need this to use map_dbl
library(estimatr)  # For starprep
library(sandwich)  # Adjust standard errors
library(lmtest)    # Recalculate model errors with sandwich functions with coeftest()
auto <- read.dta("http://www.stata-press.com/data/r9/auto.dta")
#########################################################

# Estimate regressions using lm() 
mod0 = lm(price ~ mpg                          , data=auto)
mod1 = lm(price ~ mpg                          , data=auto)
mod2 = lm(price ~ mpg + trunk                  , data=auto, subset = (price>4500))
mod3 = lm(price ~ mpg + trunk + factor(foreign), data=auto)

# Save cluster and het. robust standard errors
se0 = as.vector(summary(mod0)$coefficients[,"Std. Error"]) # Here we just pull the existing standard errors from the regression object
se1 = as.vector(coeftest(mod1,vcov = vcovCL, cluster = ~foreign)[,"Std. Error"])
se2 = as.vector(coeftest(mod2,vcov = vcovCL, cluster = ~foreign)[,"Std. Error"])
se3 = as.vector(coeftest(mod3,vcov = vcovCL, type="HC1")[,"Std. Error"])

# Calculate outcome means 
outcome_means = list(mod0, mod1, mod2, mod3) %>% map(pluck,"fitted.values") %>% map_dbl(mean)

# Make table
stargazer(mod0,mod1,mod2,mod3, type = "html",  #we use html output to match our planned R Markdown output
          title = "My price models", out = "reg_table_test.html", 
          dep.var.labels = "Price", omit.stat = c("f","ser","adj.rsq"),
          add.lines = list(c("Outcome mean", round(outcome_means,2)), 
                           c("Fixed effects","","","","x")),
          omit = c("Constant"),
          covariate.labels = c("Miles per Gallon","Trunk","Foreign"),
          se=list(se0,se1,se2,se3),
          notes=c("Column 1 gives homoskedastic standard errors.",
                  "Columns 2 and 3 show clustered standard errors.",
                  "Column 4 gives robust standard errors."), notes.align = "l")
