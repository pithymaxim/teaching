library(glmnet)
library(wooldridge)
library(ggplot2)
data("loanapp")
loanapp = na.omit(loanapp)
set.seed(1233) 

# Make vector of train indicators
train = as.logical(rbinom(n = dim(loanapp)[1], size = 1, prob = .5))

#we need to define the model equation
X <- model.matrix(approve ~ loanamt + married + dep + emp + pubrec + apr +
                    lines + mortg + hrat + sch, data=loanapp)[,-1]
#and the outcome
Y <- loanapp[,"approve"] 

# First, figure out the optimal lambda 
cv.lambda.lasso <- cv.glmnet(x=X[train,], y=Y[train],alpha = 1) 

# Get the selected lambda
selected_lambda <- cv.lambda.lasso$lambda.min

# Fit the final Lasso model using the selected lambda
lasso_model <- glmnet(X, Y, alpha = 1, lambda = selected_lambda)

# Make predictions on new data
predictions <- predict(lasso_model, newx = X[!train,])

# Make a dataframe of predictions and truth 
df = data.frame(pred = as.vector(predictions),
                truth = loanapp$approve[!train])

# Create the histogram using ggplot2
ggplot(df, aes(x = pred, fill = factor(truth))) +
  geom_histogram(position = "identity", alpha = 0.3) +
  labs(x = "Prediction", y = "Frequency") +
  scale_fill_manual(values = c("red", "green")) +
  theme_minimal()
