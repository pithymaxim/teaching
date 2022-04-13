cd $dropbox\nps\MN4111\Files\Week2_binary

cap log close 
log using worksheet2.log, replace 

eststo clear
bcuse loanapp, clear

global Xvars ltv emp dep pubrec married ln_inc ln_liq 

***************** (a)
gen ltv=loanamt/apr
hist ltv 
* Spike at 0.80. Commonly used cutoff for mortgages 

***************** (b)
gen ln_inc = ln(atotinc)
gen ln_liq = ln(liq)
regress approve $Xvars, robust

* (i) 
di "20pp increase in LTV leads to " round(100*.20*_b[ltv],1) "pp change in chance of approval"

* (ii)
binscatter approve ltv, controls(emp dep pubrec married ln_inc ln_liq )
*** Slope shows same effect (drawing not shown)

* (iii)
eststo: regress approve $Xvars, robust
estadd ysumm 

di "Marriage increases change of approval by " 100*_b[married] "pp"
local marriage_coef = _b[married]
sum approve 
di "% change: " 100*`marriage_coef' / r(mean)

* (iv)
/*
Being married is like subtracting about 13pp from 
the LTV ratio
*/
***************** (c)
regress approve ltv emp dep pubrec married ln_inc ln_liq 1.male#1.married, robust 	
di "Effects of marriage for women: " _b[married]
di "Effects of marriage for men: " 
lincom married + 1.male#1.married 

/*
Effects are slightly more helpful for men but this is not 
a statistically significant difference based on the interaction term 
*/

***************** (d)
logit approve $Xvars 
di exp(_b[ltv]) " same as the odds ratio coefficient on ltv below"
logit approve $Xvars, or 

***************** (e)

*** Store linear probability model 
eststo clear 
eststo: regress approve $Xvars, robust
/* Store the r-squared as a special scalar so that
the pseudo r-squared from the logit 
can be stored with the same name */ 
estadd scalar r2_for_table = e(r2)
estadd ysumm 

*** Store margins from logit. First run logit 
logit approve $Xvars
local logit_pseudo_r2 = e(r2_p) // store pseudo R2
sum approve if e(sample)==1 // store mean (not using estadd, which doesn't work with margins)
local logit_ymean = r(mean) // store mean (continued)
eststo: margins, dydx($Xvars) atmeans post // store margins command 
* Use estadd to attach pseudo R2 and outcome mean from logit to the stored margins coefs
estadd scalar r2_for_table = `logit_pseudo_r2'
estadd scalar ymean = `logit_ymean'

esttab , b(3) se(3) ///
stats(ymean r2_for_table N, fmt(2 3 %9.0fc) label("Outcome mean" "(Pseudo) R-squared" "Observations")) ///
mtitle("LPM" "Margins from logit")
log close 
