library(wooldridge)
library(stargazer)
library(lfe)
data(wagepan)

# This regression works 
stargazer(lm(lwage ~ hours + year + exper, data=wagepan), type="text", digits=5)

# Adding fixed effects causes a variable to be omitted
stargazer(felm(lwage ~ hours + year + exper | nr, data=wagepan), type="text", digits=5)

# Dropping experience yields the same coefficient on hours because exper was redundant!
stargazer(felm(lwage ~ hours + year         | nr, data=wagepan), type="text", digits=5)
