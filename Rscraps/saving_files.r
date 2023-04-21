################### Saving files 
# Saving file for later 
my_df = mtcars 
my_df$message = "Hello!"
head(my_df)

# Save
save(my_df, file="mtcars_altered.Rdata")

# Hit the broom to delete everything!

load(file="mtcars_altered.Rdata")
