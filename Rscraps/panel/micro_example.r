library(lfe)
library(stargazer)
df=read.csv("https://github.com/pithymaxim/teaching/raw/main/data/micro_panel.csv")

df$log_income = log(df$incomethousands)
mod1 = lm(log_income ~ married, data = df)
mod2 = lm(log_income ~ married + as.factor(year), data = df)
mod3 = felm(log_income ~ married | year + name | 0 | 0, data=df)

stargazer(mod1,mod2,mod3, type="text", keep="married")
