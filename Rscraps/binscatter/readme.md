# Simple binscatter in R #

This `binscatter.r` provides a simple function for doing a binscatter in R. There are options to use a quadratic term but NOT to add control variables. 

The code below is an example of using `source_url` from `devtools` to load the function from GitHub, and then makes a simple binscatter using the `mtcars` data.
```R
library(devtools)
library(ggplot2)

source_url("https://raw.githubusercontent.com/pithymaxim/teaching/main/Rscraps/binscatter/binscatter.r")
### Example of making binned scatterplot: 
binned_scatterplot(mtcars, x_var="disp", y_var="mpg",                     #### Required arguments 
                   num_bins=20, text_size=24,                             #### Optional arguments
                   x_axis_label="Displacement (binned)", y_axis_label = "MPG (binned)", quadratic=FALSE)
```

# Using ggplot() commands # 

Another way to do this is with the following code:
```R
library(ggplot2)
library(wooldridge)
data(twoyear)

# Need to make this a factor variable otherwise ggplot makes an ugly legend
twoyear$female = as.factor(twoyear$female)

ggplot(data = twoyear, aes(x = stotal, y = lwage, color = female)) +
  stat_summary_bin(fun='mean', bins=20, size=2, geom='point', aes(group=female)) + 
  stat_smooth(data=subset(twoyear, female==1), method = "lm") +
  stat_smooth(data=subset(twoyear, female==0), method = "lm")
```
It makes the plot below:
<img width="517" alt="image" src="https://user-images.githubusercontent.com/6835110/227786677-5419a390-727d-43bd-a722-e46700e1a34a.png">

# Things tried #

`binsreg` should be perfect for this but for some reason it fails on a maximally simple example, creating the scatter with no line.

      > binsreg(x=disp, y=mpg, data=mtcars)
      Call: binsreg

      Binscatter Plot
      Bin/Degree selection method (binsmethod)  =  IMSE direct plug-in (select # of bins)
      Placement (binspos)                       =  Quantile-spaced
      Derivative (deriv)                        =  0

      Group (by)                         =  Full Sample
      Sample size (n)                    =  32
      # of distinct values (Ndist)       =  27
      # of clusters (Nclust)             =  NA
      dots, degree (p)                   =  0
      dots, smoothness (s)               =  0
      # of bins (nbins)                  =  27

      Warning messages:
      1: In binsregselect(y, x, w, deriv = deriv, bins = dots, binspos = binspos,  :
        Too small effective sample size for DPI selection.
      2: In binsreg(x = disp, y = mpg, data = mtcars) :
        DPI selection fails. ROT choice used.
      3: In binsreg(x = disp, y = mpg, data = mtcars) :
        Too small effective sample size for dots. # of mass points or clusters used.
      4: In binsreg(x = disp, y = mpg, data = mtcars) : dots=c(0,0) used.

I should have also been able to use R's `predict` function for this, but it gets [confused](https://stackoverflow.com/questions/27464893/getting-warning-newdata-had-1-row-but-variables-found-have-32-rows-on-pred) when you try to use it to make predictions using a x variable with different names. 

