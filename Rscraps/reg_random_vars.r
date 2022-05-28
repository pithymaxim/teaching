library(foreign)

auto <- read.dta("http://www.stata-press.com/data/r9/auto.dta")

# Make a list of the 20 new variable names:
var_names = paste("random_var",1:20,sep="")

# linear regression 1: no random variables
summary(lm(price ~ mpg, data=auto))
# Call:
#   lm(formula = price ~ mpg, data = auto)
# 
# Residuals:
#   Min      1Q  Median      3Q     Max 
# -3184.2 -1886.9  -959.8  1359.7  9669.7 
# 
# Coefficients:
#   Estimate Std. Error t value Pr(>|t|)    
# (Intercept) 11253.06    1170.81   9.611 1.53e-14 ***
#   mpg          -238.89      53.08  -4.501 2.55e-05 ***
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Residual standard error: 2624 on 72 degrees of freedom
# Multiple R-squared:  0.2196,	Adjusted R-squared:  0.2087 
# F-statistic: 20.26 on 1 and 72 DF,  p-value: 2.546e-05

# Use the replicate command to make 20 columns of random variables 
auto[,var_names] = replicate(20,rnorm(n=nrow(auto)))


# Hard to use lm() with a list of variables
# (https://www.google.com/search?q=r+lm+list+of+variables+site:stackoverflow.com)

# as.formula combines text in a way that lm() will understand as linear model
fmla <- as.formula(paste("price ~ mpg +", paste(var_names, collapse= "+")))

# linear regression 2: with random variables
summary(lm(fmla, data=auto))

# Call:
#   lm(formula = fmla, data = auto)
# 
# Residuals:
#   Min      1Q  Median      3Q     Max 
# -4086.3 -1678.4  -603.4   998.9  8258.1 
# 
# Coefficients:
#   Estimate Std. Error t value Pr(>|t|)    
# (Intercept)  10172.31    1494.69   6.806 1.01e-08 ***
#   mpg           -195.63      65.43  -2.990  0.00426 ** 
#   random_var1    355.11     360.53   0.985  0.32919    
# random_var2    -67.05     385.77  -0.174  0.86269    
# random_var3    293.74     380.02   0.773  0.44305    
# random_var4    120.29     384.12   0.313  0.75541    
# random_var5    -54.42     367.48  -0.148  0.88285    
# random_var6     40.97     429.30   0.095  0.92434    
# random_var7   -446.44     391.94  -1.139  0.25990    
# random_var8   -142.03     416.43  -0.341  0.73443    
# random_var9    396.02     439.89   0.900  0.37214    
# random_var10   259.29     355.36   0.730  0.46887    
# random_var11  -123.31     490.14  -0.252  0.80236    
# random_var12   242.38     345.15   0.702  0.48565    
# random_var13   277.79     357.52   0.777  0.44068    
# random_var14   242.76     391.46   0.620  0.53788    
# random_var15  -111.81     434.56  -0.257  0.79796    
# random_var16   293.30     466.17   0.629  0.53199    
# random_var17   -96.23     362.18  -0.266  0.79153    
# random_var18  -111.39     376.31  -0.296  0.76840    
# random_var19  -599.55     427.14  -1.404  0.16637    
# random_var20  -258.02     420.81  -0.613  0.54244    
# ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Residual standard error: 2881 on 52 degrees of freedom
# Multiple R-squared:  0.3203,	Adjusted R-squared:  0.04584 
# F-statistic: 1.167 on 21 and 52 DF,  p-value: 0.3171

