library(foreign)
cancer = read.dta("http://www.stata-press.com/data/r9/cancer.dta")
cancer$treated = ifelse(cancer$drug> 1, 1, 0)

# Show means by group (95% if control died vs. 43% in treated)
aggregate(cancer$died, list(cancer$treated), FUN=mean) 

# Estimate t.test 
t.test(died~treated, data=cancer)

# Regression
summary(lm(died ~ treated, data=cancer))

# Two-stage least squares for LATE
library(AER)
cancer = read.dta("http://www.stata-press.com/data/r9/cancer.dta")
cancer$treated = ifelse(cancer$drug> 1, 1, 0)
summary(ivreg(died ~ treated | drug, data=cancer),diagnostics = TRUE)
