# Load auto data (need foreign package)
df <- read.dta("http://www.stata-press.com/data/r9/auto.dta", convert.factors = FALSE)

# Control for MPG and capture residuals, adding mean back in
df$foreign_residuals <- residuals(lm(foreign ~ mpg, data = df)) +
                        mean(df$foreign)
df$price_residuals <- residuals(lm(price ~ mpg, data = df)) + 
                        mean(df$price)

# Make plot
library(ggplot2)
ggplot(data = df, aes(x = price_residuals, y = foreign_residuals)) +
  stat_summary_bin(fun='mean', bins=15, size=4, geom='point') + 
  stat_smooth(method = "lm", se= FALSE) 
