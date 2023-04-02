library(foreign)
options(scipen=999) # turn off scientific notation 

# Load auto data 
auto <- read.dta("http://www.stata-press.com/data/r9/auto.dta", convert.factors = FALSE)

# Estimate logit 
mylogit <- glm(foreign ~ price, data = auto, family = "binomial")

# Get predicted values from model
predicted_values = predict(mylogit, type = "response")

# Show prediction for first observation
predicted_values[1]

# Show price for first observation 
auto$price[1]

# Show that when we plog that price into logit formula, we get the same probabilit
1 / (1 + exp(-1*(-1.079792 + .0000353*4099) ))

# In other words...
1 / (1 + exp(-1*(mylogit$coefficients[1] + mylogit$coefficients[2]*auto$price[1]) ))

# All match when we get when we ran
# > predicted_values[1]
