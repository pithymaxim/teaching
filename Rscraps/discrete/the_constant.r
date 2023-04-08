options(scipen=999)
df = read.csv("https://github.com/pithymaxim/teaching/raw/main/data/bam_subsample.csv")

# Regress Diff Occs on Long_unemp, College, and College*Long_unemp
summary(lm(diff_occs ~ long_unemp + college + 
             college*long_unemp, data=df))

# Constant is the mean when both dummies are zero
mean(df$diff_occs[df$long_unemp==0 & df$college==0], na.rm = TRUE)

# (This line doesn't work! Need to tell it to ignore NA values)
mean(df$diff_occs[df$long_unemp==0 & df$college==0])

# Include control variables--the constant is still the predicted
# value when all the covariates are 0. But that doesn't apply
# to anyone. 
summary(lm(diff_occs ~ long_unemp + college + 
             college*long_unemp + old_wage + year, data=df))

