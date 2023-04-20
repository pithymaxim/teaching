library(lmtest)
library(sandwich)
library(stargazer)

data = read.csv("https://github.com/pithymaxim/teaching/raw/main/Rscraps/clustering/t.csv")

# Define models
model1 <- lm(y ~ x,     data = data)
model2 <- lm(y ~ x + z, data = data)
model3 <- lm(y ~ x + b, data = data)
model4 <- lm(y ~ x + z + b, data = data)

# Make clustered SEs
se1 = as.vector(coeftest(model1,vcov = vcovCL,cluster = ~b, type="HC1")[,"Std. Error"])
se2 = as.vector(coeftest(model2,vcov = vcovCL,cluster = ~b,  type="HC1")[,"Std. Error"])
se3 = as.vector(coeftest(model3,vcov = vcovCL,cluster = ~z,  type="HC1")[,"Std. Error"])
se4 = as.vector(coeftest(model4,vcov = vcovCL,cluster = ~n,  type="HC1")[,"Std. Error"])

stargazer(model1,model2,model3,model4,type="text",
          se=list(se1,se2,se3,se4), omit=c("Constant","z","b"),
          omit.stat = c("f","ser","adj.rsq","rsq"),digits=7)
