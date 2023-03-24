# This is how #

If you're tried of running 
 ```R        
           library(rpackage)
```
every time you make a new script, you can set your `Rprofile.site` file. This is R code that is run every time you open Rstudio. 

In Windows, it's in this folder (or one like it):

        C:\Program Files\R\R-4.2.3\etc

To find where where the `etc` folder, run:

```R
    normalizePath(R.home(), winslash = "/", mustWork = FALSE)
    # (If that doesn't work, just do)
    normalizePath(R.home())
```
