# Readme for pre-registration of ``Helping out the outsourced'' #

This is a guide to the code used for Helping out the outsourced by Massenkoff and Rothstein. 

## Stata build ## 
The build is done in Stata using two dofiles:

- `A1_import.do`
- `A2_extract.do`

The second dofile makes a monthly and quarterly state-level panel giving employment and wages in the temporary help services industry.

## R code ## 

The rest happens in R. All the R code is called from `master.r` in order. Since it's short, we reproduce `master.r` below (except for loading the packages and setting the directory):

```R
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
```
The most important scripts are `synth_function.r`, which codes up the primary estimation strategies (augsynth with Ridge, vanilla synthetic control, GSYNTH) and an additional robustness check (earlier treatment date), and `main_effects.r`, which gives all the causal estimates. 
 
