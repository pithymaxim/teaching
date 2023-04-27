library(crosstable)
library(flextable)
# Make list of clean labels for columns 
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
  carb  'Number of carburetors'
")

my_test_args=crosstable_test_args()
my_test_args$show_method = FALSE

# Apply column labels to mtcars 
mydata = mtcars  %>%  import_labels(mtcars_labels, name_from="name", label_from="label")

my_table = crosstable(mydata,by=vs, test=TRUE, 
                      funs=c(mean=mean, "std error"=sd),
                      test_args=my_test_args) %>% 
  as_flextable()

save_as_html(my_table, path = "test_table.html")
browseURL("test_table.html")



