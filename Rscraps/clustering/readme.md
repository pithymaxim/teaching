# Clustering in Stata and R #

This code gives an example where R and Stata clusters yield the exact same standard errors.

## R code ## 

```R
library(lmtest)
library(sandwich)
library(stargazer)

data = read.csv("https://github.com/pithymaxim/teaching/raw/main/Rscraps/clustering/t.csv")

# Define models
model1 <- lm(y ~ x,     data = data)
model2 <- lm(y ~ x + z, data = data)
model3 <- lm(y ~ x + b, data = data)
model4 <- lm(y ~ x + z + b, data = data)

# Make clustered SEs
se1 = as.vector(coeftest(model1,vcov = vcovCL,cluster = ~b, type="HC1")[,"Std. Error"])
se2 = as.vector(coeftest(model2,vcov = vcovCL,cluster = ~b,  type="HC1")[,"Std. Error"])
se3 = as.vector(coeftest(model3,vcov = vcovCL,cluster = ~z,  type="HC1")[,"Std. Error"])
se4 = as.vector(coeftest(model4,vcov = vcovCL,cluster = ~n,  type="HC1")[,"Std. Error"])

stargazer(model1,model2,model3,model4,type="text",
          se=list(se1,se2,se3,se4), omit=c("Constant","z","b"),
          omit.stat = c("f","ser","adj.rsq","rsq"),digits=7)
```

R output:
```
================================================================
                             Dependent variable:                
             ---------------------------------------------------
                                      y                         
                 (1)          (2)          (3)          (4)     
----------------------------------------------------------------
x            2.0710530*** 2.0790100*** 2.1229310*** 2.1352580***
             (0.1026263)  (0.1244470)  (0.1486790)  (0.1114778) 
                                                                
----------------------------------------------------------------
Observations     100          100          100          100     
================================================================
Note:                                *p<0.1; **p<0.05; ***p<0.01
```
## Stata code ##

```
insheet using https://github.com/pithymaxim/teaching/raw/main/Rscraps/clustering/t.csv, comma names clear 
eststo clear 
eststo: regress y x, cluster(b)
eststo: regress y x z, cluster(b) 
eststo: regress y x b , cluster(z)
eststo: regress y x z b, cluster(n)

esttab , b(7) se(7) keep(x)
```
Stata output: 
```
. esttab ,  b(7) se(7) keep(x)

----------------------------------------------------------------------------
                      (1)             (2)             (3)             (4)   
                        y               y               y               y   
----------------------------------------------------------------------------
x               2.0710530*      2.0790104*      2.1229313***    2.1352581***
              (0.1026263)     (0.1244470)     (0.1486790)     (0.1114778)   
----------------------------------------------------------------------------
N                     100             100             100             100   
----------------------------------------------------------------------------
Standard errors in parentheses
* p<0.05, ** p<0.01, *** p<0.001
```

## Use felm() in R? ## 

Using felm's cluster syntax did not give the same results. This is the code I use (it couldn't estimate model3 but those were strange clusters).

```R
data = read.csv("https://github.com/pithymaxim/teaching/raw/main/Rscraps/clustering/t.csv")

model1 <- felm(y ~ x | NULL | b,     data = data)
model2 <- felm(y ~ x + z | NULL | b, data = data)
# model3 <- felm(y ~ x + b | NULL | z, data = data)
model4 <- felm(y ~ x + z + b | NULL | n, data = data)

stargazer(model1,model2,model4,type="text",
           omit=c("Constant","z","b"),
          omit.stat = c("f","ser","adj.rsq","rsq"),digits=7)
```


