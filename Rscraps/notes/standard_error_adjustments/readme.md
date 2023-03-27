# Standard error adjustments in R regressions # 

Making standard error adjustments in R can be complicated. If you're using the `stargazer` package, which is the best way to make regression tables, you will find it breaks when you change the SEs in the `lm()` model objects directly. (`lm_robust()` doesn't work with `stargazer` either unfortunately!)

Instead, I've found the best way is to make a vector containing your new standard errors (SEs), and then explicitly pass those to `stargazer`. 

Here's how:

```R
library(stargazer) # For pretty tables 
library(lmtest)    # For coeftest
library(sandwich)  # For vcovHC

# Estimate a regression using lm() 
mod1 = lm(mpg ~ disp +hp + factor(cyl) , data=mtcars)

# Save vectors of clustered and robust standard errors for Columns 2 and 3
se2 = as.vector(coeftest(mod1,vcov = vcovHC, type="HC1")[,"Std. Error"])     # Robust (Heteroskedasticity consistent) SEs
se3 = as.vector(coeftest(mod1,vcov = vcovHC, cluster = ~cyl)[,"Std. Error"]) # Cluster SEs at "cyl" level

# Make table
stargazer(mod1,mod1,mod1, type = "text",  se=list(NULL,se2,se3), notes.align = "l",
          notes=c("Column 1: homoskedastic", "Column 2: robust standard errors", "Column 3: clustered standard errors."))
```
The key argument in `stargazer` is `se=list(NULL,se2,se3)`. We set it to `NULL` for the first model because there we're using the SEs that it comes with. The other two models will swap in the vectors we made above, `se2` and `se3`. 

The line making `se2` will always suffice to get "robust" standard errors. It uses specific arguments to match [how Stata calculates them]([url](https://stats.stackexchange.com/questions/117052/replicating-statas-robust-option-in-r)) (R does something slightly different by default).

Here's the (abbreviated) output from the `stargazer` line:
```
          ====================================================================
                                                         mpg                  
                                             (1)          (2)          (3)    
          --------------------------------------------------------------------
          disp                            -0.026**     -0.026***    -0.026*** 
                                           (0.010)      (0.009)      (0.010)  

          hp                               -0.021       -0.021**     -0.021   
                                           (0.014)      (0.011)      (0.013)  

          factor(cyl)6                    -4.047**     -4.047***    -4.047*** 
                                           (1.689)      (1.446)      (1.535)  

          factor(cyl)8                     -2.432        -2.432      -2.432   
                                           (3.240)      (2.785)      (3.032)  

          Constant                        31.148***    31.148***    31.148*** 
                                           (1.767)      (1.789)      (1.927)  
          ====================================================================
          Note:                         *p<0.1; **p<0.05; ***p<0.01           
                                        Column 1: homoskedastic               
                                        Column 2: robust standard errors      
                                        Column 3: clustered standard errors. 
```
## Two faster options ## 

Here are two shorter ways to view our robust standard errors if don't need a table.

### 1. Using lm_robust() ###
This command from the `estimator` package works:
```R
library(estimatr)
lm_robust(mpg ~ disp +hp + factor(cyl) , data=mtcars, se_type="HC1")
```
### 2. Using coeftest ###
We used this above in the longer example, but in this case we're not trying to make a nice table so we can strip away the code that stores the vector of SEs.
```R
library(lmtest)
library(sandwich)

mymodel = lm(mpg ~ disp +hp + factor(cyl) , data=mtcars)
coeftest(mymodel, vcov = vcovHC(mymodel, type="HC1"))
```

## Details: showing R code matching Stata's robust SEs ##

In Stata:
```Stata
* Load mtcars (from a github url)
insheet using https://gist.githubusercontent.com/seankross/a412dfbd88b3db70b74b/raw/5f23f993cd87c283ce766e7ac6b329ee7cc2e1d1/mtcars.csv
regress mpg disp hp i.cyl , robust
```
Output: 

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
> as.vector(coeftest(lm(mpg ~ disp +hp + factor(cyl) , data=mtcars),vcov = vcovHC, type="HC1")[,"Std. Error"])
[1] 1.789208108 0.008754031 0.010781349 1.446403698 2.785364276
```
