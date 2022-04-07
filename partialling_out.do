*** Partialling out example 
sysuse auto, clear

global control_vars trunk turn length 

regress price $control_vars 
predict price_resid, resid  

regress mpg $control_vars 
predict mpg_resid, resid 

regress price_resid mpg_resid 
regress price mpg $control_vars 
