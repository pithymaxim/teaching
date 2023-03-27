# Standard error adjustments in R regressions # 

Making standard error adjustments in R can be complicated. If you're using the `stargazer` package, which is the best way to make regression tables, you will find it breaks when you change the SEs in the `lm()` model objects directly.

Instead, you have to make a vector containing your new standard errors, and then explicitly pass those to `stargazer`. 

Here's the full code showing how to do this:

```R
library(stargazer) # For pretty tables 
library(lmtest)    # For coeftest
library(sandwich)  # For vcovCL

# Estimate regressions using lm() 
mod1 = lm(mpg ~ disp +hp + factor(cyl) , data=mtcars)

# Save cluster and het. robust standard errors
se1 = as.vector( summary(mod1)$coefficients[,"Std. Error"])                      # Here we just pull the existing standard errors from the regression object
se2 = as.vector(coeftest(mod1,vcov = vcovCL, type="HC1")[,"Std. Error"])        # Robust (Heteroskedasticity consistent) SEs
se3 = as.vector(coeftest(mod1,vcov = vcovCL, cluster = ~cyl)[,"Std. Error"]) # Cluster SEs at "foreign" level

# Make table
stargazer(mod1,mod1,mod1, type = "text",  se=list(se1,se2,se3),
          notes=c("Column 1 gives homoskedastic standard errors.",
                  "Column 2 gives robust standard errors.",
                  "Column 3 gives clustered standard errors."), notes.align = "l")
```
