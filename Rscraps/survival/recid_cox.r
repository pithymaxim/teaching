# Load the survival package
library(survival)
library(stargazer)
# Load a dataset
data(recid)

# Make the arrested indicator
recid$arrested = 1 - recid$cens

# Fit a Cox proportional hazards regression model
fit = coxph(Surv(durat, arrested) ~ priors + tserved + felon + 
                    property + rules+  alcohol + married, data = recid)

# Summarize the model
summary(fit)

Output:
#   coxph(formula = Surv(durat, arrested) ~ priors + tserved + felon + 
#           property + rules + alcohol + married, data = recid)
# 
# n= 1445, number of events= 552 
# 
# coef exp(coef)  se(coef)      z Pr(>|z|)    
# priors    0.044026  1.045009  0.011994  3.671 0.000242 ***
#   tserved   0.008695  1.008733  0.001705  5.101 3.38e-07 ***
#   felon    -0.478990  0.619409  0.140567 -3.408 0.000655 ***
#   property  0.402915  1.496179  0.138132  2.917 0.003536 ** 
#   rules     0.049518  1.050765  0.014965  3.309 0.000936 ***
#   alcohol   0.278774  1.321509  0.104167  2.676 0.007446 ** 
#   married  -0.318500  0.727239  0.105094 -3.031 0.002440 ** 
