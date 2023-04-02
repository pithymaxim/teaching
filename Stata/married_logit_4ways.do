sysuse nlsw88, clear
gen age_sq = age^2
eststo clear

eststo m1: logit  married  c_city age 
eststo m2: margins , dydx( c_city age) post atmeans
eststo m3: regress married  c_city age 

sum married  
esttab m1 m1 m2 m3, eform(0 1 0 0)  ///
       mtitle("Log odds" "Odds ratios" "Marginal" "LPM") b(3) se(3) ///
	   nocons 
	   
