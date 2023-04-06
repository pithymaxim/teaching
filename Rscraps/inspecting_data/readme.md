# Inspecting data

Here is R code showing the basic things you can do to inspect a dataset.

```R
# Load data 
data(mtcars)

# Show the number of rows and columns (shows rows first, then columns):
dim(mtcars)
# Output: [1] 32 11

# Show variable names and their types (this one is boring because every variable is numeric)
str(mtcars)

# Look at the first 10 rows
head(mtcars)

# Summarize the variables 
#    read more on the <out> options here https://rdrr.io/cran/vtable/man/sumtable.html
library(vtable)
sumtable(mtcars, out="return")
summary(mtcars)

# View Average and SD by group
print(aggregate(mpg ~ gear, data = mtcars, 
                function(x) c(mean = mean(x), sd = sd(x), min=min(x), max=max(x))), 
      digits=3)

```

# Notes on the different commands 

## sumtable ##

The `sumtable` command makes some very slick summary statistics. Here is the output:

<img width="353" alt="image" src="https://user-images.githubusercontent.com/6835110/230488731-efe04704-8918-453e-b60a-81b60a4096fa.png">

## summary ##

The built-in `summary(mtcars)` also works, I just find the output hader to read:

```
      mpg             cyl             disp             hp             drat      
 Min.   :10.40   Min.   :4.000   Min.   : 71.1   Min.   : 52.0   Min.   :2.760  
 1st Qu.:15.43   1st Qu.:4.000   1st Qu.:120.8   1st Qu.: 96.5   1st Qu.:3.080  
 Median :19.20   Median :6.000   Median :196.3   Median :123.0   Median :3.695  
 Mean   :20.09   Mean   :6.188   Mean   :230.7   Mean   :146.7   Mean   :3.597  
 3rd Qu.:22.80   3rd Qu.:8.000   3rd Qu.:326.0   3rd Qu.:180.0   3rd Qu.:3.920  
 Max.   :33.90   Max.   :8.000   Max.   :472.0   Max.   :335.0   Max.   :4.930  
 ...
 ```

## aggregate ##

The `aggregate()` function is a way to show means and other summary stats **by group**. In this example, we show the mean, SD, min, and max of `mpg` for every unique value of `gear`:

```R
print(aggregate(mpg ~ gear, data = mtcars, 
                function(x) c(mean = mean(x), sd = sd(x), min=min(x), max=max(x))), 
      digits=3)
```
The output is:
```
  gear mpg.mean mpg.sd mpg.min mpg.max
1    3    16.11   3.37   10.40   21.50
2    4    24.53   5.28   17.80   33.90
3    5    21.38   6.66   15.00   30.40
```
This kind of thing is useful because it allows you to quickly assess average differences across groups and to locate any problem observations. If you only want means, the quick version is
```R
aggregate(mpg ~ gear, data = mtcars, FUN = mean) 
```
which returns
```
 gear      mpg
1    3 16.10667
2    4 24.53333
3    5 21.38000
```
