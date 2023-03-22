library(devtools)
library(ggplot2)

source_url("https://raw.githubusercontent.com/pithymaxim/teaching/main/Rscraps/binscatter/binscatter.r")
### Example of making binned scatterplot: 
binned_scatterplot(mtcars, x_var="disp", y_var="mpg",                     #### Required arguments 
                   num_bins=20, text_size=24,                             #### Optional arguments
                   x_axis_label="Displacement (binned)", y_axis_label = "MPG (binned)", quadratic=FALSE)
