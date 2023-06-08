# Using ggplot() commands # 

We use `stat_summary_bin` and `stat_smooth` from `ggplot`. Here's a simple example:
```R
library(ggplot2)
ggplot(data = mtcars, aes(x = mpg, y = wt)) +
  stat_summary_bin(fun='mean', bins=20, size=4, geom='point') + 
  stat_smooth(method = "lm", se= FALSE) 
```
It makes this plot:

<img width="555" alt="image" src="https://user-images.githubusercontent.com/6835110/227791221-c9f5f2a5-f25c-418b-b218-50cc03d365e6.png">

## Quadratic or Cubic fits ## 

Also, it's easy to do a quadratic or cubic fit. You adjust the `stat_smooth` line. This makes a quadratic fit:
```R
stat_smooth(method = "lm", formula = y ~ poly(x, 2, raw = TRUE), se= FALSE) 
```
## Splitting by group ## 
Here I show how you can pretty easily split by a variable (`female` in this case).
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

## Connected plots of means at each discrete value (by group) ## 

The code below makes this plot: average log wage every year, split by married and unmarried:
![image](https://github.com/pithymaxim/teaching/assets/6835110/ac06006c-0c5a-43be-a44b-1e837aa46f84)


```R
library(wooldridge)
library(ggplot2)
data(wagepan)
wagepan$married = as.factor(wagepan$married)
ggplot(data = wagepan, aes(x = year, y = lwage, 
                           factor = married, color = married, linetype = married)) +
  stat_summary(fun = "mean", geom = "line") +
  stat_summary(fun = "mean", geom = "point") +
  theme_bw() +
  scale_linetype_manual(values = c("solid", "dashed"), labels = c("Not Married", "Married")) +
  scale_colour_manual(values = c("blue", "red"), labels = c("Not Married", "Married")) +
  theme(legend.title = element_blank())
```

# Simple binscatter function in R #

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

# Simple connected plot # 

`binscatter` can also be used to show the averages for every discrete value of a variable (`binscatter... , discrete linetype(connect)`). Here's the R analogue:

```R
library(wooldridge)
library(ggplot2)
data(wagepan)

ggplot(wagepan, aes(x = year, y = lwage)) +
  stat_summary(fun.y = "mean", geom = "line", color = "blue", size = 1) +
  stat_summary(fun.y = "mean", geom = "point", shape = 21, fill = "blue", color = "black", size = 4) +
  xlab("Year") +
  ylab("Log Wage") +
  ggtitle("Mean Log Wage by Year") +
  theme_bw() 
```
It makes this plot:

![image](https://github.com/pithymaxim/teaching/assets/6835110/6965a2b7-a3e4-4034-93f4-f4e8b435424d)


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

