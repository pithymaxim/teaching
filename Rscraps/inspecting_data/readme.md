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

## aggregate ##

The `aggregate()` function is a way to show means <by group>
