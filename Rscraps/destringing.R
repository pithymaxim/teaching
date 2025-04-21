library(haven)
library(ggplot2)
df = read_dta("https://github.com/pithymaxim/teaching/raw/refs/heads/main/data/cwbh_extract.dta")

# --------------- Destringing 
# Issue! These lines don't work
ggplot(data=df, aes(x=total_weeks_claimed)) + geom_histogram()
mean(df$total_weeks_claimed, na.rm = TRUE)

# Can't just run as.numeric
df$num_weeks_claimed = as.numeric(df$total_weeks_claimed)

# Identify the problematic values
non_numeric = df$total_weeks_claimed[is.na(as.numeric(df$total_weeks_claimed))]
table(non_numeric)

# Replace "*" with NA
df$total_weeks_claimed[df$total_weeks_claimed == "*"] = NA

# No error message
df$total_weeks_claimed = as.numeric(df$total_weeks_claimed)

# Histogram works!
ggplot(data=df, aes(x=total_weeks_claimed)) + geom_histogram()

# ---------------  Recoding missing values. 

# People at 99 are actually missing!
ggplot(data=df, aes(x=birth_year)) + geom_histogram()
df$birth_year[df$birth_year==99] = NA
ggplot(data=df, aes(x=birth_year)) + geom_histogram()
