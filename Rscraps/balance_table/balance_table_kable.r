library(tableone)
library(kableExtra)

############# EDIT THESE  ############################################
# The name of your dataframe 
df_name = "mtcars" 

# The names of the two groups (e.g. treatment, control)
group1_name = "V engine"
group2_name = "Straight engine"

# The variables you want to show
varlist = c("am","carb","disp","cyl","mpg","gear","vs")

# The categorical variables from that list
factors = c(                   "cyl",      "gear","vs")

# The variable you want to split on
split_by = "vs"

# Pretty name labels. Same order as varlist 
pretty_names = c("Manual","Number of carburetors","Displacement","Cylinders","MPG","Forward Gears","VS")

# A note you want to add at the bottom
my_note = "This table shows descriptive statistics for the two primary groups in the analysis. For continuous variables, we show means with standard deviations in parentheses. For categorical variables, we give the frequency of that value with the percent in parentheses."
#####################################################################

# Create TableOne object 
bt = CreateTableOne(vars = varlist, 
                    factorVars = factors, strata = split_by, 
                    data = get(df_name)) 


# Now loop through to edit rownames 
new_rownames <- c("N")
rows_to_indent = c()

# Loop over each item in varlist 
for (item in varlist) {
  pretty_name = pretty_names[which(varlist==item)]
  # For categorical variables, add extra rows (one for each value)
  if (item %in% factors) {
    # Only shows multiple rows if there are 3 cats or more 
    if (length(names(table(get(df_name)[item])))>2) {
      new_rownames <- c(new_rownames, paste0(pretty_name," (%)"), names(table(get(df_name)[item])))
      index = which(new_rownames==paste0(pretty_name," (%)"))
      rows_to_indent = c(rows_to_indent,seq(index+1,index+length(names(table(get(df_name)[item])))))
    } else {
      new_rownames <- c(new_rownames, paste0(pretty_name," (%)"))
    }
    
  } else {
    new_rownames <- c(new_rownames, pretty_name)
  }
}

# Print the TableOne output 
df = as.data.frame(print(bt, quote=FALSE, noSpaces = TRUE)) 
names(df) = c(group1_name,group2_name,"P-value of difference","")
df2 = as.matrix(df)

rownames(df2) = new_rownames

# Delete last column (not used)
df2 = df2[,-4]


if (length(rows_to_indent) > 0) {
  kable(df2, format = "html") %>% 
    kable_styling() %>%
    add_footnote(my_note) %>%
    add_indent(rows_to_indent)
} else {
  kable(df2, format = "html") %>% 
    kable_styling() %>%
    add_footnote(my_note) 
}
