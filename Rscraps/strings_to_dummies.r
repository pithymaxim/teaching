library(haven)
library(stringr)
df = read_dta("http://www.stata-press.com/data/r8/auto.dta")

# Make a dummy equal to 1 if the string variable contains certain characters 
df$vw = as.numeric(str_detect(df$make,"VW"))

# Show the instances of vw
table(auto$vw)

# Confirm that it did the right thing
df$make[df$vw==1]

# Can do this for multiple strings
words = 'VW|Toyota'
df$vw_or_toyota = as.numeric(str_detect(df$make,words))

# Confirm that it did the right thing
df$make[df$vw_or_toyota==1]

# Make a very specific dummmy 
df$celica = as.numeric(df$make=="Toyota Celica")

# Now we have numeric dummies based on strings!
summary(lm(price ~ celica + vw + vw_or_toyota, data = df))

# Split up a string variable (this splits at every space)
splitvars <- str_split(df$make, " ", simplify = TRUE)
df$company <- splitvars[,1]

# Confirm that it worked
table(df$company)

# Now we can run a regression with company fixed effects
summary(lm(price ~ factor(company), data = df))


