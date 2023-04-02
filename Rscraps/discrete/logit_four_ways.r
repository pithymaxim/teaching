library(haven)
library(margins)
df <- read_dta("https://www.stata-press.com/data/r17/nlsw88.dta")

### Estimate coefficients

# [1] Logit model 
logit = glm(married ~ c_city + age, data=df , family = "binomial")

# [2] Marginal effects from logit model 
logit_margins = margins(model1)

# [3] Linear Probability model (LPM)
LPM = lm(married ~ c_city + age, data=df)

### Display coefficients 

# Logit coefficients (Log odds ratio)
logit$coefficients

# Logit coefficients (Odds ratio)
exp(logit$coefficients)

# Marginal effects from logit 
logit_margins

# Linear probability model 
LPM$coefficients
