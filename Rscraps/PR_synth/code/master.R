# install.packages("augsynth")
# devtools::install_github("ebenmichael/augsynth")
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

# Load Stata files, build outcomes, save to RDS
sink("code/R_side_build.log")
source("code/R_side_build.r", echo = TRUE, max.deparse.length=Inf)
sink()

### Used only for pre-registration #################
# Perform placebo runs for power calculations (takes ~6 hours without parallelizing)
source("code/placebo_runs.r")

# Make placebo table 
source("code/make_placebo_table.r")
####################################################

# Load needed functions for causal estimates 
source("code/synth_function.r")
source("code/augsynth_plots.r")

# Show the fits from 2001-2022
source("code/show_fits_for_prereg.r")

# Main estimates 
source("code/main_effects.r")
