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
summary(lm(def_wage ~ married, data=wagepan))

# Adding person fixed effects (uses lfe package)
# After the "~" is a four-part formula: 
# (1) Covariates
# (2) Factors to be projected out (i.e., fixed effects)
# (3) Instruments (set to 0 to not use)
# (4) Level at which to cluster standard errors (set to 0 to not use)
summary(felm(def_wage ~ married |nr | 0 | 0, wagepan), robust="T")

### Demeaning. Take group-level averages with "ave" function
wagepan$demeaned_wage = wagepan$def_wage - ave(wagepan$def_wage, wagepan$nr)
wagepan$demeaned_married = wagepan$married - ave(wagepan$married, wagepan$nr)

# Showing the right number of decimals is annoying...
# https://stackoverflow.com/questions/65341848/how-can-i-print-a-certain-number-of-decimals-digits-in-r-when-scipen-and-digits
round(summary(lm(demeaned_wage ~ demeaned_married, data=wagepan))$coefficients, 4)

### Two way fixed effects 
# What's with the "0 | 0" ? Explanation: 
# The formula specification is a response variable followed by a four part formula. 
# The first part consists of ordinary covariates, the second part consists of factors to be projected out. 
# The third part is an IV-specification. The fourth part is a cluster specification for the standard errors. 
# Source: https://rdrr.io/cran/lfe/man/felm.html
summary(felm(def_wage ~ married |nr + year| 0 | 0, wagepan), robust="T")

# Interact with hisp (hisp gets dropped, that's OK)
summary(felm(def_wage ~ married*hisp |nr + year| 0 | 0, wagepan), robust="T")

