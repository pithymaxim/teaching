# Making a histogram in R #

## Simple discrete histogram ##

To make a simple discrete histogram in R, use this code:

    library(ggplot2)
    ggplot(mtcars, aes(x=carb)) + geom_bar()

## Discrete overlaid histogram ## 

This code makes an overlaid histogram. See the [documentation](http://www.sthda.com/english/wiki/ggplot2-histogram-plot-quick-start-guide-r-software-and-data-visualization) for more.

    ggplot(mtcars) +
    geom_histogram(aes(x=carb, group=vs, fill=factor(vs)), 
                 color="black",position = "identity", alpha=0.4, binwidth = 0.5) + 
    scale_fill_manual(name="Value of vs",labels=c("vs=0","vs=1"), values=c("red","blue"))
