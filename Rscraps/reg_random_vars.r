library(foreign)

auto <- read.dta("http://www.stata-press.com/data/r9/auto.dta")

# Make a list of the 20 new variable names:
var_names = paste("random_var",1:20,sep="")

# linear regression 1: no random variables
summary(lm(price ~ mpg, data=auto))

# Use the replicate command to make 20 columns of random variables 
auto[,var_names] = replicate(20,rnorm(n=nrow(auto)))


# Hard to use lm() with a list of variables
# (https://www.google.com/search?q=r+lm+list+of+variables+site:stackoverflow.com)

# as.formula combines text in a way that lm() will understand as linear model
fmla <- as.formula(paste("price ~ mpg +", paste(var_names, collapse= "+")))

# linear regression 2: with random variables
summary(lm(fmla, data=auto))

