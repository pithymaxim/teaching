# Standard error adjustments in R regressions # 

Making standard error adjustments in R can be complicated. If you're using the `stargazer` package, which is the best way to make regression tables, you will find it breaks when you change the SEs in the `lm()` model objects directly. (`lm_robust()` doesn't work with `stargazer` either unfortunately!)

Instead, you have to make a vector containing your new standard errors, and then explicitly pass those to `stargazer`. 

Here's the full code showing how to do this:

```R
library(stargazer) # For pretty tables 
library(lmtest)    # For coeftest
library(sandwich)  # For vcovCL

# Estimate a regression using lm() 
mod1 = lm(mpg ~ disp +hp + factor(cyl) , data=mtcars)

# Save vectors of clustered and robust standard errors for Columns 2 and 3
se2 = as.vector(coeftest(mod1,vcov = vcovCL, type="HC1")[,"Std. Error"])     # Robust (Heteroskedasticity consistent) SEs
se3 = as.vector(coeftest(mod1,vcov = vcovCL, cluster = ~cyl)[,"Std. Error"]) # Cluster SEs at "cyl" level

# Make table
stargazer(mod1,mod1,mod1, type = "text",  se=list(NULL,se2,se3), notes.align = "l",
          notes=c("Column 1: homoskedastic", "Column 2: robust standard errors", "Column 3: clustered standard errors."))
```
The key argument in `stargazer` is `se=list(NULL,se2,se3)`. We set it to `NULL` for the first model because there we're using the SEs that it comes with. The other two models will swap in the vectors we made above, `se2` and `se3`. 
