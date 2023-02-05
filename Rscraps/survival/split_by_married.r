### Difficult to get survminer to load. Needed these:
install.packages("tidyselect") # Helps with survminer
install.packages("cli") # Had to manually delete "cli.dll" from computer to get this line to work
install.packages("rstatix")
################
# Follows the guide here: https://thriv.github.io/biodatasci2018/r-survival.html

library(ggpubr)
library(survminer)
library(survival)
library(wooldridge)

data("recid")
recid$arrested = 1 - recid$cens

km_split <- survfit(Surv(durat, arrested) ~ married, data=recid)

# Made the months into yearly labels. See the arguments explained here: http://rpkgs.datanovia.com/survminer/reference/ggsurvplot_arguments.html
ggsurvplot(km_split, xscale=12, break.x.by=12, xlim=c(0,7*12),
          ylab="Share not yet arrested", xlab="Years")


