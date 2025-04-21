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
Now, the saved CSV will have a note colum and its first row says:
```
Made by JohnSmith on 2025-04-21 09:54:02.663897 in my_script.R
```

Note that you should updated `my_script.R` to be the name of the actual script! This bakes in a paper trail documenting your data build.
