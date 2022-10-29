library(foreign)
library(margins)

auto <- read.dta("http://www.stata-press.com/data/r9/auto.dta")

# Run logistic regression
auto$foreign.dummy = ifelse(auto$foreign=="Foreign",1,0)
mylogit <- glm(foreign.dummy ~ mpg + price, data = auto, family = "binomial")
summary(mylogit)

# Calculate marginal effects 
# (these are average marginal effects, not "at means")
margins(mylogit)

