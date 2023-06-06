# Making a balance table in R # 

## Using CreateTableOne and kable ##

![image](https://github.com/pithymaxim/teaching/assets/6835110/5ede387b-b693-4f31-801a-e3d01ada5b10)



## Another option ## 
The code below makes this table using the `crosstable` and `flextable` packages. Full script [here](https://github.com/pithymaxim/teaching/blob/main/Rscraps/balance_table/balance_table_example.r).

![image](https://user-images.githubusercontent.com/6835110/234989855-e004f29d-f8c2-444b-99e3-ec1eec1bd255.png)

First, we load the libraries:
```r
library(crosstable)
library(flextable)
```
Then, we label all the variables using this [code](https://cran.r-project.org/web/packages/crosstable/vignettes/crosstable.html).

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
To make some changes to the hypothesis tests that `crosstable` does, we need to create a special object that holds the arguments. Code from [here](https://rdrr.io/cran/crosstable/man/crosstable_test_args.html).
```r
my_test_args=crosstable_test_args()
my_test_args$show_method = FALSE
```
Then we're ready to make the table. The `by` argument says how to split up the data. "vs" is a variable in mtcars. The table will have one column for vs=0 and one column for vs=1. `test=TRUE` says to report p-values in the last column testing if the two columns are different. Finally, the `funs` argument asks for the mean and the standard error, as is typical.
```r
my_table = crosstable(mydata,by=vs, test=TRUE, 
                      funs=c(mean=mean, "std error"=sd),
                      test_args=my_test_args) %>% 
  as_flextable()
```
Next we just need to save the table. Saving it as an HTML is the easiest way of getting a publication-ready version:
```r 
save_as_html(my_table, path = "test_table.html")
browseURL("test_table.html")
```



