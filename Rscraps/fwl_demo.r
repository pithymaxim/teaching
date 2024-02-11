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

