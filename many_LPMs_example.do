clear all 
bcuse recid, clear

gen arrested = 1 - cens
stset durat, failure(arrested)

global controls black alcohol drugs super felon workprg property person priors educ rules age tserved

stcox married
stcox married  $controls
stcurve, hazard 	

tempfile tmp
tempname poster 

local lpm 1
local logit 0

postfile `poster' float month b se b_controls se_controls share_arrested using `tmp' 

forvalues i = 1/48 {
	gen arrested`i' = durat<=`i' if !(cens==1 & durat<=`i')
	sum arrested`i'
	local share_arrested = r(mean)
	if `lpm' {
		eststo m`i': regress arrested`i' married $controls, robust 
		local b_controls = _b[married]
		local se_controls = _se[married]
		eststo m`i': regress arrested`i' married 
	}
	if `logit' {
		logit arrested`i' married  $controls
		eststo m`i': margins, dydx(married) post 
		local b_controls = _b[married]
		local se_controls = _se[married]
		eststo m`i': logit arrested`i' married 
		eststo m`i': margins, dydx(married) post 
	}
	post `poster' (`i') (_b[married]) (_se[married]) (`b_controls') (`se_controls') (`share_arrested')
}
postclose `poster'
clear
use `tmp', clear
gen upper_bound = b + 2*se
gen lower_bound = b - 2*se

gen upper_bound_ctrl = b_controls + 2*se_controls
gen lower_bound_ctrl = b_controls - 2*se_controls

gen month_offset = month+.3


twoway (scatter b month, mc(blue%50) msize(small))  /// 
       (rcap upper_bound lower_bound month, lc(blue%10..) lw(vthin..) ), ///
	   ytitle(Effect) title(Effect on Pr(Arrested in month 1 to {it:t})) xlabel(0(6)48) xtitle(Month ({it:t})) /// 
	    graphregion(fcolor(white)) plotregion(fcolor(white)) yline(0,axis(1)) legend(off)
		

twoway (scatter b month, mc(blue%50) msize(small))  /// 
       (rcap upper_bound lower_bound month, lc(blue%10..) lw(vthin..) ) ///
	   (scatter b_controls month_offset, mc(red%50) msize(small))  /// 
       (rcap upper_bound_ctrl lower_bound_ctrl month_offset, lc(red%10..) lw(vthin..) ), ///
        legend(order(1 "No controls" 3 "Controls")) ytitle(Effect) title(Effect on Pr(Arrested in month 1 to {it:t})) xlabel(0(6)48) xtitle(Month ({it:t})) /// 
	    graphregion(fcolor(white)) plotregion(fcolor(white)) yline(0,axis(1))  
		
