data(bwght)

# (1): regress cigs on faminc
cigs_vs_faminc <- lm(cigs ~ faminc, data = bwght)
# Save the residuals of the first regression
bwght$cigs_vs_faminc_residual <- resid(cigs_vs_faminc)

# (2): regress bwght on faminc
bwght_vs_faminc <- lm(bwght ~ faminc, data = bwght)
# Save the residuals of the second regression
bwght$bwght_vs_faminc_residual <- resid(bwght_vs_faminc)

# (3): These two regressions get the same coefficient on cigs:
stargazer(lm(bwght_vs_faminc_residual ~ cigs_vs_faminc_residual, data = bwght), type="text")
stargazer(lm(bwght ~ cigs + faminc, data = bwght), type="text")

# With categorical control:

library(haven)
library(dplyr)
library(broom)
df = read_dta("http://www.stata-press.com/data/r9/auto.dta")

# --- (1)
# Regress price on mpg, and then price on mpg and foreign
summary(lm(price ~ mpg, data = df))
summary(lm(price ~ mpg + foreign, data = df))

# --- (2) Demeaning. Take group-level averages with "ave" function
df$price_demeaned = df$price   - ave(df$price, df$foreign)
df$mpg_demeaned   = df$mpg - ave(df$mpg, df$foreign)

# Take the residual from regressing price on foreign
df$price_resid_vs_foreign <- residuals(lm(price ~ foreign, data = df))

# Show that price_demeaned and price_resid_vs_foreign are identical
summary(lm(price_demeaned ~ price_resid_vs_foreign, data = df))

# --- (3) 
# Regression using demeaned variables
lm1 = lm(price_demeaned ~ mpg_demeaned, data = df)
lm2 = lm(price ~ mpg + foreign, data = df)
stargazer(lm1,lm2,type="text")
