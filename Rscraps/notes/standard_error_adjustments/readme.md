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

## Details: showing how to match Stata's robust SEs ##

In Stata:
```Stata
insheet using https://gist.githubusercontent.com/seankross/a412dfbd88b3db70b74b/raw/5f23f993cd87c283ce766e7ac6b329ee7cc2e1d1/mtcars.csv
regress mpg disp hp i.cyl , robust
```
Output: 
                                                          Number of obs     =         32
                                                          F(4, 27)          =      25.95
                                                          Prob > F          =     0.0000
                                                          R-squared         =     0.8001
                                                          Root MSE          =     2.8875

          ------------------------------------------------------------------------------
                       |               Robust
                   mpg | Coefficient  std. err.      t    P>|t|     [95% conf. interval]
          -------------+----------------------------------------------------------------
                  disp |  -.0260375    .008754    -2.97   0.006    -.0439993   -.0080757
                    hp |   -.021136   .0107814    -1.96   0.060    -.0432575    .0009855
                       |
                   cyl |
                    6  |  -4.047191   1.446404    -2.80   0.009    -7.014966   -1.079415
                    8  |  -2.431926   2.785364    -0.87   0.390    -8.147022     3.28317
                       |
                 _cons |   31.14773   1.789208    17.41   0.000     27.47658    34.81888
          ------------------------------------------------------------------------------
In R:
```R
as.vector(coeftest(lm(mpg ~ disp +hp + factor(cyl) , data=mtcars),vcov = vcovHC, type="HC1")[,"Std. Error"])
```
