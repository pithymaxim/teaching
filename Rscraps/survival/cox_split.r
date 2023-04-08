# Load the required packages
library(survival)
library(ggfortify)
library(survminer)

data("recid")

# Make the arrested indicator
recid$arrested = 1 - recid$cens

# Fit a Cox proportional hazards regression model with only <married> and plot the results 
res.cox      = coxph(Surv(durat, arrested) ~ married, data = recid)
fit = survfit(res.cox, newdata=data.frame(married=c(0,1)))
ggsurvplot(fit, data=recid, conf.int = TRUE, legend.labs=c("Unmarried", "Married"),
           ggtheme = theme_minimal())

# Now add controls 
res.cox.ctrls = coxph(Surv(durat, arrested) ~ married + black+ 
                        alcohol+ drugs+ super+ felon +workprg+ property+ person +priors+
                        educ +rules +age+ tserved, data = recid)
# The survfit function explicitly needs a dataframe where we hold
# all other variables constant but still allow our married
# indicator to vary.

# We doe this in fake_df. 
# This code makes a dataframe with 2 rows. Each column is its average
# from recid (repeated across rows) except for married, which 
# is 0 or 1
fake_df = data.frame(cbind(married=c(0,1),rbind(colMeans(recid),colMeans(recid))))
fit = survfit(res.cox.ctrls, newdata=fake_df)
ggsurvplot(fit, data=recid, conf.int = TRUE, legend.labs=c("Unmarried", "Married"),
           ggtheme = theme_minimal())


