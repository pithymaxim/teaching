library(haven)
library(augsynth)
library(lubridate)
library(dplyr)
library(cdlTools) # For fips ==> state names 
library(xtable) # For dataframe ==> latex table 
library(ggplot2)
library(quantmod) # For CPI 
library(seasonal) 
library(gsynth) # For progfunc = 'gsyn' in augsynth

# *********** set filepaths ************ #
setwd(file.path(dropbox, "berkeley/projects/PR_synth"))
out_folder = file.path(dropbox, "Apps/Overleaf/PR_Synth/exhibits")
out_folder = file.path(dropbox, "berkeley/projects/PR_synth/out")
# ************************************** #

# === Run parameters ========================================= #
# Set outcomes:
outcome_list = c("month_emplvl","month_emplvl_sa","ln_month_emplvl_sa","ln_month_emplvl_ratio",
                 "avg_wkly_wage","avg_wkly_wage_sa","ln_avg_wkly_wage_sa","ln_avg_wkly_wage_ratio") 

technique_list = c("Ridge","GSYN","none")

output_to_overleaf = F
var_num = "_all"

# For parallel
if (interactive()==F) {
  use_sink = T
  args <- commandArgs(trailingOnly = TRUE)
  var_num <- as.numeric(args[1])
  print(paste0("var_num: ",var_num))
  outcome_list = outcome_list[var_num:var_num]
}

if (use_sink) {
  filename <- paste("code/placebo_logs/placebo_runs_", var_num, ".log", sep = "")
  sink(filename)
}

# === Run parameters ========================================= #

# Define the function
synth_runner <- function(outcome = NULL, synth_method = "augsynth", technique="Ridge", 
                         remove_border_states = F, placebo = F, testing = F, jackknife=F) {
  
  #================ Function diagnostics 
  # Check if first_name is provided
  if(is.null(outcome)) {
    stop("The argument 'outcome' must be provided.")
  }
  # Print all the provided arguments
  message("Running synth_runner() with \n",
          "\ttechnique= ", technique, "\n",
          "\toutcome= ", outcome, "\n",
          "\tremove_border_states= ", remove_border_states, "\n",
          "\tsynth_method= ", synth_method)
  
  #================ Data setup 
  if (grepl("wage",outcome)) {
    df = readRDS("inter/temp_only_build_state_sa.rds")
    time_unit = "quarter"
  }
  if (grepl("emp",outcome)) {
    df = readRDS("inter/temp_only_build_state_monthly_sa.rds")
    time_unit = "month" 
  }
  
  #=== Non-bordering states 
  if (remove_border_states) {
    df = subset(df, !state %in% c(36, 42, 10))
    suffix = paste0(suffix,"_non_border")
  }
  
  #================ Synth run
  if (technique=="Ridge" | technique=="none") {
  code_line <- paste('synth_result <- augsynth(', outcome, ' ~ treated,', 
                     'state, r_date, df,', 
                     'progfunc = ', paste0('"',technique,'"'),', scm = T)')
  }
  else {
    code_line <- paste('synth_result <-gsynth(', outcome, 
                       ' ~ treated, data = df, index = c("state","r_date"))')
  }
  print(code_line)
  print("Performing placebo")   

  # Drop the (fake) observations from 2023
  df = subset(df, df$year<2023)

  # Make the vector of treat dates 
  ATT_ests = c()
  if (time_unit == "month") {
    treat_dates = as.Date(seq(min(df$r_date) + years(1), max(df$r_date) - years(1), by = "1 month"))
  }
  if (time_unit == "quarter") {
    treat_dates = as.Date(seq(min(df$r_date) + years(5), max(df$r_date) - years(1), by = "3 months"))
  }
  if (testing) {
    treat_dates = treat_dates[1:4]
  }
  
  # Loop through each treat date 
  for (new_treat_date in treat_dates) {
    print( paste0("Current placebo treatment date: ", as.Date(new_treat_date)) )
    new_treat_date = as.Date(new_treat_date)
    
    # Re-assign treated column 
    df[df$state==34,"treated"] = df[df$state==34,]$r_date >= new_treat_date
    print(paste0("Total treated periods: ", sum(df$treated)))
    
    # Estimate synth 
    print(paste0("This is the treated date: ", new_treat_date))
    eval(parse(text=code_line))
    print("Eval synth done")
    
    # In the last period, get the jackknife estimates 
    if (new_treat_date==max(treat_dates) & technique!= "GSYN" & jackknife==T) {
      print("Last treat date. Doing jackknife+")
      jackknife_sum = summary(synth_result, inf_type = "jackknife+")$average_att
      alt_CI_over_2 = (jackknife_sum$upper_bound - jackknife_sum$lower_bound)/2
      print("Done with jackknife")
    }
    if (new_treat_date==max(treat_dates) & technique=="GSYN" & jackknife==T) {
      code_line <- paste('synth_result <-gsynth(', outcome, 
                         ' ~ treated, data = df, index = c("state","r_date"), inference="jackknife",se=TRUE )')
      eval(parse(text=code_line))
      alt_CI_over_2 = (synth_result$est.avg[,"CI.upper"]  - synth_result$est.avg[,"CI.lower"] )/2 
    }
    
    # Save ATT
    if (technique!="GSYN") {
      att = predict(synth_result, att = T)
    }
    else {
      att = synth_result$att
    }
    att_subset = att[names(att)>=new_treat_date & names(att)<new_treat_date + years(1)]
    ATT_ests = c(ATT_ests, 
                 mean(att_subset)) 
    print(paste0("check ATT length: ",
                 length(att_subset)))
    print("Placebo done")
  }
  print("placebo done")
  num_treat_dates = length(treat_dates)
  min_treat_date = min(treat_dates)
  max_treat_date = max(treat_dates)
  print(paste0("Length treat dates: ",num_treat_dates))
  print("95% CI over 2: ")
  CI_width =  (quantile(ATT_ests, probs = 0.975)-quantile(ATT_ests, probs = 0.025))
  NJ_mean  = mean(df[df$state==34 & df$year==2022,][[outcome]])
  print(CI_width/2 ) 
  print(paste0("NJ outcome mean: ", NJ_mean, "Outcome: ",outcome))
  return(list(ATT_ests=ATT_ests, treat_dates=as.Date(treat_dates),
              att=att,CI_width=CI_width,NJ_mean=NJ_mean,num_treat_dates=num_treat_dates,
              min_treat_date=min_treat_date,max_treat_date=max_treat_date,
              alt_CI_over_2=alt_CI_over_2))
}

# Initialize DF for holding results 
placebo_results <- data.frame(
  Outcome = character(0),
  Technique = character(0),
  CI_width_over2 = numeric(0),
  NJ_mean = numeric(0),
  N_dates = numeric(0),
  alt_CI_over_2 = numeric(0)
)
######## end testing 

for (my_outcome in outcome_list) {
  for (my_prog_func in technique_list) {
    print(paste0("Outcome: ",my_outcome," ", my_prog_func))
    run_result = synth_runner(outcome = my_outcome, technique = my_prog_func, 
                              placebo=T, testing=F,jackknife=T)
    placebo_results = add_row(placebo_results, 
                              Outcome = my_outcome, 
                              Technique=my_prog_func, 
                              CI_width_over2 = run_result$CI_width / 2,
                              NJ_mean = run_result$NJ_mean,
                              N_dates = run_result$num_treat_dates,
                              alt_CI_over_2=run_result$alt_CI_over_2)
    print(paste0("Running results: \n"))
    print(placebo_results)
    saveRDS(placebo_results, paste("inter/placebo_results", var_num, ".rds", sep = ""))
  }
}
  
if (output_to_overleaf) {
  # Make into integers with commas
  placebo_results <- placebo_results %>%
    mutate(across(where(is.numeric), ~ format(as.integer(.), big.mark = ",")))
  
  latex_table <- xtable(placebo_results)
  output <- capture.output(print(latex_table, type = "latex", include.rownames = FALSE, floating = FALSE))
  writeLines(output, file.path(out_folder, "placebo_table.tex"))
}
if (use_sink) {
  sink()
}

