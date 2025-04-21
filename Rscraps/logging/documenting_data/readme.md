# Documenting a dataset before you save it

A useful way to document your data work is to always include a little note in a `note` column of the dataframe:

```r
df = read.csv("https://github.com/pithymaxim/teaching/raw/refs/heads/main/data/marathon_times.csv")
df$note = NA  # Initialize the column first
df$note[1] = paste0("Made by ", Sys.getenv("USERNAME"), " on ", Sys.time(), " in my_script.R")
print(df$note[1])
# Save your data, for example as a CSV:
write.csv(df,"updated_df.csv", na = "")
```
