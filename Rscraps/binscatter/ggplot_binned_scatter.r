library(ggplot2)
ggplot(data = mtcars, aes(x = mpg, y = wt)) +
  stat_summary_bin(fun='mean', bins=20, size=4, geom='point') + 
  stat_smooth(method = "lm", se= FALSE) 
