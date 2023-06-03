### Categorical variables 
data("affairs")
summary(lm(kids ~ factor(relig), data=affairs)) 

# Show means
aggregate(affairs$kids, list(affairs$relig), mean)

library(car)
model = lm(kids ~ factor(relig), data=affairs)
linearHypothesis(model, "factor(relig)2 = factor(relig)5")
