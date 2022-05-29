library(stargazer)
library(foreign)
auto <- read.dta("http://www.stata-press.com/data/r9/auto.dta")
stargazer(auto, type='html', out='test.html', median=TRUE,
          digits=2,
          notes="<i>Note</i>: Here are my notes to the table.This is some notes. Here is what happens if they are particularly long.",
          covariate.labels =c("Price","Miles per Gallon"))
