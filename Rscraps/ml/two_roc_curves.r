library(wooldridge)
library(pROC)

############### Setup 
# Load loanapp data 
data(loanapp)

# Drop all missing values 
loanapp = na.omit(loanapp)

# Make vector of train indicators
train = as.logical(rbinom(n = dim(loanapp)[1], size = 1, prob = .5))

############### Model estimation
logit1 = glm(approve ~ male + married + dep, data = subset(loanapp, train), family="binomial")
logit2 = glm(approve ~ male + married + dep  + price 
             + liq + pubrec, data = subset(loanapp, train), family="binomial")

############### Model evaluation
# Get predictions 
p1 = predict(logit1,newdata=subset(loanapp, train==0))
p2 = predict(logit2,newdata=subset(loanapp, train==0))

# Calculate ROC
roc_score1 =roc(loanapp$approve[train==0], p1) #AUC score
roc_score2 =roc(loanapp$approve[train==0], p2) #AUC score

# Make plot 
plot(roc_score1,main ="ROC curve -- Logistic Regression", print.auc = TRUE, col = "blue")
plot(roc_score2, print.auc = TRUE, 
                 col = "green", print.auc.y = .4, add = TRUE)
