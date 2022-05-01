# Safewater regressions 
lx <- read.dta("http://www.stata-press.com/data/r9/lifeexp.dta")
# Remove those with missing safewater:
lx <- lx[complete.cases(lx$safewater), ] 
lx$gnppc = lx$gnppc/1000
summary(lm(lexp ~ gnppc, data=lx))
summary(lm(lexp ~ gnppc + safewater, data=lx))
