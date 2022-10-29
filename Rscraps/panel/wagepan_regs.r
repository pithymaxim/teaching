library(wooldridge)
library(lubridate)
library(collapse)
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
lm(def_wage ~ married, data=wagepan)

