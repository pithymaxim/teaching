### Functional form 
auto <- read.dta("http://www.stata-press.com/data/r9/auto.dta")

# Linear 
summary(lm(price ~ mpg, data=auto))
# Log-linear 
summary(lm(log(price) ~ mpg, data=auto))
# Log-log 
summary(lm(log(price) ~ log(mpg), data=auto))
# Linear-log 
summary(lm(price ~ log(mpg), data=auto))
