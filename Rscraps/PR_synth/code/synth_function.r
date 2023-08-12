# Define the function
synth_runner <- function(outcome = NULL, synth_method = "augsynth", 
                         technique="Ridge", remove_border_states = F,
                         treated_jan_2023 = F) {
  suffix=""
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
  
  #=== Alternative treatment 
  if (treated_jan_2023) {
    df$treated = as.numeric(df$state==34 & df$year>=2023)
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
  eval(parse(text=code_line))
  print(summary(synth_result))
  return = list(result = synth_result, 
                  code = code_line)
}

