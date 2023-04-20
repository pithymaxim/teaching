library(lmtest)
library(sandwich)
library(stargazer)

set.seed(44)

# Load data
data <- data.frame(
  x = rnorm(100),
  z = rnorm(100),
  b = rbinom(100, 1, 0.5),
  n = rpois(100, 10)
)
data$y <- 0.5 + 2 * data$x + 0.1 * data$z + 0.5 * data$b - 0.1 * (data$x - 0.5) ^ 2 + rnorm(100)

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
          omit.stat = c("f","ser","adj.rsq","rsq"),digits=10)

          
