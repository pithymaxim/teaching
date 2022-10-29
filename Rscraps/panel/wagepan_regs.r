library(wooldridge)
library(lubridate)
library(collapse)
library(lfe)
data("wagepan")

#### Merge in CPI
# Read in the data 
cpi = read.csv("https://datahub.io/core/cpi-us/r/cpiai.csv")
# https://stackoverflow.com/questions/36568070/extract-year-from-date

# Make year variable (uses lubridate package)
cpi$year = year(ymd(cpi$Date))

# Collapse to yearly level (uses collapse package)
annual_cpi <- collap(cpi, Index ~ year, FUN = list(fmean))

# Merge with wagepan data on year
wagepan = merge(wagepan,annual_cpi,by="year")

# Make variable with deflated wages 
wagepan$def_wage = wagepan$lwage - log(wagepan$Index)

### Estimate regression
# Simple bivariate regression 
lm(def_wage ~ married, data=wagepan)

# Adding person fixed effects (uses lfe package)
# After the "~" is a four-part formula: 
# (1) Covariates
# (2) Factors to be projected out (i.e., fixed effects)
# (3) Instruments (set to 0 to not use)
# (4) Level at which to cluster standard errors (set to 0 to not use)
summary(felm(def_wage ~ married |nr | 0 | 0, wagepan), robust="T")


