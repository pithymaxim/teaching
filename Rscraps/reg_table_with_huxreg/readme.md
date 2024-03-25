This is a fully working example of a regression table with `huxreg` and `flextable`:

```r
library(flextable)
library(huxtable)

# Load data 
auto <- read.dta("http://www.stata-press.com/data/r9/auto.dta")

# Estimate regressions using lm() 
model1 = lm(price ~ mpg                          , data=auto)
model2 = lm(price ~ mpg                          , data=auto)
model3 = lm(price ~ mpg + trunk                  , data=auto, subset = (price>4500))
model4 = lm(price ~ mpg + trunk + factor(foreign), data=auto)

outcome_means <- lapply(list(model1, model2, model3, model4), function(reg) mean(reg$model$price))
outcome_means <- unlist(outcome_means)

foreign_fixed_effects = c("","","","X")

ht = huxreg("Baseline"=model1, "Model 2"=model2, "Model 3" = model3, "Model 4" = model4, 
            number_format = "%10.3f",
            note = "Time fixed effects denotes fixed effects for year and month.",
            coefs=c("Miles per gallon"="mpg","Trunk"="trunk"),
            statistics = c("N. obs." = "nobs", 
      "R squared" = "r.squared"))
ht = add_rows(ht,c("Foreign fixed effects", race_fixed_effects), after=nrow(ht)-3, copy_cell_props=FALSE)
ht = add_rows(ht,c("Outcome mean", outcome_means_formatted), after=nrow(ht)-3,copy_cell_props=FALSE)
ht = set_align(ht,value="center")
ht = set_align(ht, col = 1, value = 'left')
# Edit individual row format:
number_format(ht[nrow(ht)-3,]) = fmt_pretty()
print(ht)
```
This is what gets outputted:

![image](https://github.com/pithymaxim/teaching/assets/6835110/b3e24c91-b8df-4c06-8c32-0ca8857fff41)
