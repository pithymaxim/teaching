# Inspecting data

Here is R code showing the basic things you can do to inspect a dataset.

```R
# Load data 
data(mtcars)

# Show the number of rows and columns (shows rows first, then columns):
dim(mtcars)

# Show variable names and their types
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
