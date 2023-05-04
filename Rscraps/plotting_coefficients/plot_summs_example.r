library(wooldridge)
library(jtools)
data(recid)
recid$arrested = recid$cens==0

mod1 = lm(arrested ~ alcohol + drugs, data = recid)
mod2 = lm(arrested ~ alcohol + drugs + priors + age + tserved + married, data = recid)

logit = glm(arrested ~ alcohol + drugs + priors + age + tserved + married,
             data = recid, family = binomial())
mod3 = margins(logit, type = "response")

plot_summs(mod1, mod2,mod3,
           model.names=c("LPM: Fewer controls","LPM: More controls","Logit: More controls"),
           coefs = c("Past alcohol violation"="alcohol","Past drug violation"="drugs"),
           legend.title = "Model")
