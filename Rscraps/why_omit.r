### Why did R omit my variable?
library(wooldridge)
data("bwght")
bwght$female = 1 - bwght$male
summary(lm(bwght ~ female + male, data=bwght))
