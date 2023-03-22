# Making a histogram in R #

## Simple discrete histogram ##

To make a simple discrete histogram in R, use this code:

    library(ggplot2)
    ggplot(mtcars, aes(x=carb)) + geom_bar()

<img width="474" alt="image" src="https://user-images.githubusercontent.com/6835110/226800072-36c1f293-dfe2-43c6-a93b-4c4921eb99e7.png">


## Discrete overlaid histogram ## 

This code makes an overlaid histogram. See the [documentation](http://www.sthda.com/english/wiki/ggplot2-histogram-plot-quick-start-guide-r-software-and-data-visualization) for more.

    ggplot(mtcars) +
    geom_histogram(aes(x=carb, group=vs, fill=factor(vs)), 
                 color="black",position = "identity", alpha=0.4, binwidth = 0.5) + 
    scale_fill_manual(name="Value of vs",labels=c("vs=0","vs=1"), values=c("red","blue"))


<img width="466" alt="image" src="https://user-images.githubusercontent.com/6835110/226799999-3fa09d87-b92c-4163-996a-251c4ef6409a.png">
