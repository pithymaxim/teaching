library(glmnet)
library(wooldridge)
library(ggplot2)
library(haven)

# Remove NA and make outcome 
df = read_dta("Army.dta")
df = na.omit(df)
df = df[!duplicated(df),]
df$early_attrite = as.logical(df$tis < 36)

# Make vector of train indicators
train = as.logical(rbinom(n = dim(df)[1], size = 1, prob = .5))

# Define outcome variable
outcome = "early_attrite"
# Make list of predictors 
predictors = c("afqt", "accession_date", "female", "hs", "nohi", 
                  "married", "year", "ed_level")

# First, figure out the optimal lambda 
cv.lambda.lasso <- cv.glmnet(x=as.matrix(df[train,predictors]), 
                             y=as.matrix(df[train,outcome]),alpha = 1) 

# Get the selected lambda
selected_lambda <- cv.lambda.lasso$lambda.min

# Fit the final Lasso model using the selected lambda
lasso_model <- glmnet(x=as.matrix(df[train,predictors]), 
                      y=as.matrix(df[train,outcome]), 
                      alpha = 1, lambda = selected_lambda)

# Make predictions on new data
predictions <- predict(lasso_model, newx = as.matrix(df[!train,predictors]))

# Make a dataframe of predictions and truth 
pred_df = data.frame(pred = as.vector(predictions),
                truth = df[[outcome]][!train])

# Create the histogram using ggplot2
ggplot(pred_df, aes(x = pred, fill = factor(truth))) +
  geom_histogram(position = "identity", alpha = 0.3) +
  labs(x = "Prediction", y = "Frequency") +
  scale_fill_manual(values = c("green", "red"),
                    labels = c("Did not attrite", "Attrited early"),
                    name="True Attrition Status") +
  theme_minimal() + 
  geom_vline(xintercept = 0.6)+
  geom_vline(xintercept = 0.4)
