library(wooldridge)
library(lubridate)
library(collapse)
library(lfe)

############################## Preliminaries
### Load data 
data("wagepan")

#### Merge in CPI and deflate wages 
# Read in CPI data 
cpi_df = read.csv("https://github.com/pithymaxim/teaching/raw/main/misc/cpi.csv")

# Merge with wagepan data on year
wagepan = merge(wagepan,cpi_df,by="year")

# Make variable with deflated wages 
wagepan$def_wage = wagepan$lwage - log(wagepan$cpi)

############################## Regressions  
######## Simple bivariate regression 
stargazer(lm(def_wage ~ married, data=wagepan), type="text", digits=5)

######## Adding person fixed effects (uses lfe package)
# After the "~" is a four-part formula: 
# (1) Covariates
# (2) Factors to be projected out (i.e., fixed effects)
# (3) Instruments (set to 0 to not use)
# (4) Level at which to cluster standard errors (set to 0 to not use)
# Source: https://rdrr.io/cran/lfe/man/felm.html
stargazer(felm(def_wage ~ married |nr | 0 | 0, wagepan), type="text", digits=5)

######## Demeaning. Take group-level averages with "ave" function
wagepan$demeaned_wage =    wagepan$def_wage - ave(wagepan$def_wage, wagepan$nr)
wagepan$demeaned_married = wagepan$married  - ave(wagepan$married, wagepan$nr)

# Show demeaned regression
stargazer(lm(demeaned_wage ~ demeaned_married, data=wagepan), digits=5, type="text")

######## Two way fixed effects 
stargazer(felm(def_wage ~ married |nr + year| 0 | 0, wagepan), digits=5, type="text")

######## Two way deameaning:
wagepan$demeaned2_wage =    wagepan$def_wage - ave(wagepan$def_wage, wagepan$year) -
                                              ave(wagepan$def_wage, wagepan$nr)
wagepan$demeaned2_married = wagepan$married  - ave(wagepan$married, wagepan$year) - 
                                               ave(wagepan$married, wagepan$nr)

# Show demeaned regression (coefs are same as two way fixed effects regression)
stargazer(lm(demeaned2_wage ~ demeaned2_married, data=wagepan), digits=5, type="text")

######## Interaction 
# Interact with hisp (hisp gets dropped, that's OK!)
stargazer(felm(def_wage ~ married*hisp |nr + year| 0 | 0, wagepan), digits=5, type="text")

######## Clustering at the <nr> level
mod_twfe           = felm(def_wage ~ married |nr + year| 0 | 0, wagepan)
mod_twfe_clustered = felm(def_wage ~ married |nr + year| 0 | nr, wagepan)

# See that the standard errors change but not the coefs
stargazer(mod_twfe,mod_twfe_clustered,digits=5,type="text")

