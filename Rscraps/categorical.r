### Categorical variables 
data("affairs")
summary(lm(kids ~ factor(relig), data=affairs)) 

# Show means
aggregate(affairs$kids, list(affairs$relig), mean)
