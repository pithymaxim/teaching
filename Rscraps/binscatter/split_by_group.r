library(ggplot2)
library(wooldridge)
data(twoyear)

# Need to make this a factor variable otherwise ggplot makes an ugly legend
twoyear$female = as.factor(twoyear$female)

ggplot(data = twoyear, aes(x = stotal, y = lwage, color = female)) +
  stat_summary_bin(fun='mean', bins=20, size=2, geom='point', aes(group=female)) + 
  stat_smooth(data=subset(twoyear, female==1), method = "lm") +
  stat_smooth(data=subset(twoyear, female==0), method = "lm")
