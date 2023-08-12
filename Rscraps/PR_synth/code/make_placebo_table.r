# Create an empty list to store the dataframes
dataframes <- list()

for (i in c(1:8)) {
  file_name <- paste0("inter/placebo_results", i, ".rds")
  dataframes[[i]] <- readRDS(file_name)
}

df = do.call(rbind, dataframes)

df$alt_CI_over_2[df$alt_CI_over_2 < 0] = NA

df$percent <- ifelse(grepl("ln_", df$Outcome), 100*df$CI_width_over2, 100*df$CI_width_over2/df$NJ_mean)

df$Type <- ifelse(grepl("wage", df$Outcome), "Wage", "Emp.")

df = df[order(df$Type,df$percent),]

df$Outcome  <- name_mapping[df$Outcome]

df$N_dates = as.integer(df$N_dates)

print(df)

table_df = df[,c("Type","Outcome","Technique","CI_width_over2","NJ_mean", "N_dates","alt_CI_over_2","percent")]

table_df <- rename(table_df, `CI/2` = CI_width_over2)
table_df <- rename(table_df, `Jackknife` = alt_CI_over_2)
table_df <- rename(table_df, `As Percent` = percent)
table_df <- rename(table_df, `NJ Mean` = NJ_mean)
table_df <- rename(table_df, `N dates` = N_dates)

# Save weights to .tex 
latex_table <- xtable(table_df)
output <- capture.output(print(latex_table, Type = "latex", include.rownames = FALSE, floating = FALSE))
# Add hline where outcome switches from emp to wages 
output[18] <- paste(output[18], "\\hline")

writeLines(output, file.path(out_folder, "placebo_runs_table.tex"))


