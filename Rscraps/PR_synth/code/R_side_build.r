name_mapping <- c("avg_wkly_wage" = "Avg. wage",
                  "avg_wkly_wage_sa" = "Avg. wage (seas. adj.)",
                  "month_emplvl" = "Emp.",
                  "month_emplvl_sa" = "Emp. (seas. adj.)",
                  "ln_month_emplvl_sa" = "Ln(Emp.) (seas. adj.)",
                  "ln_month_emplvl_ratio" = "Ln(Emp.) - Ln(State Emp.)",
                  "ln_avg_wkly_wage_sa" = "Ln(Avg. wage) (seas. adj.)",
                  "ln_avg_wkly_wage_ratio" = "Ln(Avg. wage) - Ln(State wage)")


deflate_wages <- function(df, outcome) {
  # === Merge in CPI 
  getSymbols("CPIAUCSL", src = "FRED")
  CPI_data <- data.frame(date=index(CPIAUCSL), CPIAUCSL=coredata(CPIAUCSL))
  colnames(CPI_data) <- c("r_date", "CPI")
  
  cpi_reference <- CPI_data[CPI_data$r_date == "2023-01-01", "CPI"]
  CPI_data$deflator <- CPI_data$CPI / cpi_reference
  
  df <- left_join(df, CPI_data, by = "r_date")
  
  # Need to give nonsense data to the "fake data" periods (2023)
  df[is.na(df$deflator), "deflator"] <- 1
  
  # Deflate average weekly wage 
  df[[outcome]] <- df[[outcome]] / df$deflator
  
  return(df)
}

seasonal_adj <- function(df, outcome, freq, datevar) {
  # Sort 
  df <- df %>% arrange(state, r_date)
  seas_results <- data.frame()
  
  # Get the unique state values
  unique_states <- unique(df$state)
  
  # Initialize dataframe 
  seas_results = data.frame()
  
  # Loop over the unique states
  for(state in unique_states){
    print(paste0("Starting state ", state))
    # Subset the data for the current state 
    df_state = df[df$state==state & df$fake_data==0,]

    # Make a time series object
    ts_state <- ts(df_state[[outcome]], frequency = freq, 
                   start = c(min(df_state$year), min(df_state[[datevar]])))
    
    # Perform the seasonal adjustment
    seas_state <- seas(ts_state)
    
    # Add seasonally adjusted data to the dataframe
    result = final(seas_state)
    
    # New column name 
    seas_adj_col = paste0(outcome,"_sa")
    
    result_df = data.frame(state = rep(state,length(result)), 
                           year = df_state$year)
    result_df[[seas_adj_col]] = as.vector(result)
    result_df[[datevar]] = df_state[[datevar]]
    
    seas_results = bind_rows(seas_results,result_df)
  }
  
  # all.x=TRUE to keep the fake_date, which will not match with seas_results
  df = merge(df, seas_results, by = c("state", "year", datevar), all.x=TRUE)
  
  # Fill in the fake data columns with random values
  if (sum(df$fake_data)>0) {
    df[[seas_adj_col]][df$fake_data == 1] = runif(sum(df$fake_data))
  }
  print(max(df$year))
  return(df)
}

# =============== Make r date, seasonally adjust, make log vars
# === Quarterly data
df = read_dta("inter/temp_only_build_state.dta")
df$r_date <- as.Date(df$stata_date, origin = "1960-01-01")

# Deflate wages 
df = deflate_wages(df,"avg_wkly_wage")

# Seasonally adjust
df = seasonal_adj(df,"avg_wkly_wage",        4, "qtr")
df = seasonal_adj(df,"agg_st_avg_wkly_wage", 4, "qtr")

# Take logs and ratios 
df$ln_avg_wkly_wage_sa =    log(df$avg_wkly_wage_sa)
df$ln_avg_wkly_wage_ratio = log(df$avg_wkly_wage_sa) - log(df$agg_st_avg_wkly_wage_sa)

# Save the dataframe to a CSV file
summary(df)
saveRDS(df, "inter/temp_only_build_state_sa.rds")

# === Monthly data
df = read_dta("inter/temp_only_build_state_monthly.dta")
df$r_date <- as.Date(df$stata_date, origin = "1960-01-01")

# Seasonally adjust
df = seasonal_adj(df,"month_emplvl",        12, "month")
df = seasonal_adj(df,"agg_st_month_emplvl", 12, "month")

# Take logs and ratios 
df$ln_month_emplvl_sa =    log(df$month_emplvl_sa)
df$ln_month_emplvl_ratio = log(df$month_emplvl_sa) - log(df$agg_st_month_emplvl_sa)

# Save the dataframe to a CSV file
summary(df)
saveRDS(df, "inter/temp_only_build_state_monthly_sa.rds")


