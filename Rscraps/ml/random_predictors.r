library(foreign)

auto = read.dta("http://www.stata-press.com/data/r9/auto.dta")

auto$foreign = as.numeric(auto$foreign=="Foreign")
mean(auto$foreign)

# Make vector of train indicators
train = rbinom(n = dim(auto)[1], size = 1, prob = .5)

# Make a list of the new variable names:
var_names = paste("random_var",1:40,sep="")

# Use the replicate command to make many columns of random variables 
auto[,var_names] = replicate(40,rnorm(n=nrow(auto)))

# Hard to use lm() with a list of variables
# (https://www.google.com/search?q=r+lm+list+of+variables+site:stackoverflow.com)

train_df = subset(auto, subset=as.logical(train))
dim(train_df)

# as.formula combines text in a way that lm() will understand as linear model
fmla <- as.formula(paste("foreign ~ mpg +", paste(var_names, collapse= "+")))

# linear regression 2: with random variables
model = lm(fmla, data=train_df)

predictions = predict(model, newdata=auto)
predict_foreign = as.numeric(predictions > 0.5)
mean(predict_foreign)

# What share did we get correct in the TRAIN data?
mean(predict_foreign[train==1]==train_df$foreign)
# What share did we get correct in the TEST data?
mean(predict_foreign[train==0]==auto[train==0,]$foreign)


