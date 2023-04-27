# Making a balance table in R # 

The code below makes this table using the `crosstable` and `flextable` packages:

![image](https://user-images.githubusercontent.com/6835110/234988092-bfd63520-2937-4b87-b3d6-9b958c21b0c4.png)

First, we load the libraries:
```r
library(crosstable)
library(flextable)
```
Then, we label all the variables using this code ([from here]([url](https://cran.r-project.org/web/packages/crosstable/vignettes/crosstable.html)))

```r
mtcars_labels = read.table(header=TRUE, text="
  name  label
  model 'Model'
  mpg   'Miles/(US) gallon'
  cyl   'Number of cylinders'
  disp  'Displacement (cu.in.)'
  hp    'Gross horsepower'
  drat  'Rear axle ratio'
  wt    'Weight (1000 lbs)'
  qsec  '1/4 mile time'
  vs    'Engine'
  am    'Transmission'
  gear  'Number of forward gears'
  carb  'Number of carburetors'")
  
  ### Apply labels to the columns in mtcars
  mydata = mtcars  %>%  import_labels(mtcars_labels, name_from="name", label_from="label")
  ```
To make some changes to the hypothesis tests that `crosstable` does, we need to create a special object that holds the arguments (code from [here]([url](https://rdrr.io/cran/crosstable/man/crosstable_test_args.html)))
```r
my_test_args=crosstable_test_args()
my_test_args$show_method = FALSE
```
