library(ggplot2)
library(wooldridge)
data(wagepan)

wagepan$married = as.factor(wagepan$married)

ggplot(data = wagepan, aes(x = year, y = lwage, color = married)) +
  stat_summary_bin(fun='mean', bins=20, size=5, geom='point', aes(group=married)) + 
  stat_smooth(data=subset(wagepan, married==1), method = "lm", se =FALSE) +
  stat_smooth(data=subset(wagepan, married==0), method = "lm",se =FALSE) +
  theme_bw() + 
  theme(axis.text=element_text(size=25),
        axis.title=element_text(size=25,face="bold"),
        legend.text=element_text(size=25),
        legend.title=element_text(size=25)) 
 
