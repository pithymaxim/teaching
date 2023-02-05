library(wooldridge)
library(ggplot2)
data('cement')

ggplot(data=cement, 
       mapping=aes(x=month, y=ipcem)) + 
       stat_summary(fun=mean, geom="line") + 
       scale_x_continuous(labels=1:12, breaks=1:12)
