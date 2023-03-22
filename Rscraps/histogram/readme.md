# Making a histogram in R #

## Simple discrete histogram ##

To make a simple discrete histogram in R, use this code:

    library(ggplot2)
    ggplot(mtcars, aes(x=carb)) + geom_bar()
