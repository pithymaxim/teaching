library(survival)
### Fake data 
surv_df = read.csv("https://raw.githubusercontent.com/pithymaxim/teaching/main/data/simple_survival.csv")

# Make the Kaplan-Meier Survival Plot 
km_fit <- survfit(Surv(months, death)~1, data=surv_df)

# Output the Kaplan Meier table
summary(km_fit)
