# Simple binscatter in R #

This code provides a simple function for doing a binscatter in R. There are options to use a quadratic term but NOT to add control variables. 

```R
# Comment
print(hello)
```

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

