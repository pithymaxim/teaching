# Load required packages
library(wooldridge)  # For loanapp dataset
library(dplyr)       # For data manipulation
library(ggplot2)     # For plotting

# Load the loanapp dataset
data(loanapp)

# Create training set (50% random split)
loanapp$train <- runif(nrow(loanapp)) < 0.50

# Find which columns are between dep and gift
all_cols <- names(loanapp)
dep_index <- which(all_cols == "dep")
gift_index <- which(all_cols == "gift")
predictor_cols <- all_cols[dep_index:gift_index]

# Run logistic regression on training set with specified predictors
predictors <- c("dep", "emp", "yjob", "self", "atotinc", "cototinc", "hexp", "price", 
                "other", "liq", "rep", "gdlin", "lines", "mortg", "cons", "pubrec", 
                "hrat", "obrat", "fixadj", "term", "apr", "prop", "inss", "inson", "gift")
formula_str <- paste("married ~", paste(predictors, collapse = " + "))
model <- glm(as.formula(formula_str), 
             data = loanapp[loanapp$train == 1, ], 
             family = binomial)

# Generate predictions for all observations
loanapp$married_hat <- predict(model, newdata = loanapp, type = "response")

# Keep only test set
test_data <- loanapp[loanapp$train == 0, ]

# Create deciles of predicted probabilities
test_data$married_hat_dec <- ntile(test_data$married_hat, 10)

# Calculate mean married and mean married_hat by decile
summary_data <- test_data %>%
  group_by(married_hat_dec) %>%
  summarize(married = mean(married),
            married_hat = mean(married_hat))

# Create scatter plot with 45-degree line
ggplot(summary_data, aes(x = married_hat, y = married)) +
  geom_point() +
  geom_abline(intercept = 0, slope = 1) +
  labs(x = "Predicted probability married", y = "Share married") +
  theme_minimal() +
  theme(panel.background = element_rect(fill = "white"))
