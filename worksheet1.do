cd $dropbox\nps\MN4111\Files\Week1_multivariate_review
set more off 
set linesize 200 
cap log close
log using worksheet1.log, replace 

*****************************************************
*** Q2 **********************************************
*****************************************************
******** (a)
bcuse bwght, clear 
hist bwght 
hist cigs, discrete frac
******** (b)
scatter    bwght cigs 
binscatter bwght cigs 

******** (e)
regress bwght cigs, robust
regress bwght cigs faminc, robust

*****************************************************
*** Q3 **********************************************
*****************************************************
bcuse gpa2, clear

******** (a)
binscatter sat hsize

******** (b)
gen ln_sat = ln(sat)
reg athlete hsperc female ln_sat, robust

******** (c)
reg colgpa sat
reg colgpa sat hsize 
reg colgpa sat hsize hsperc 

*****************************************************
*** Q5 **********************************************
*****************************************************
bcuse bwght, clear
eststo clear 
eststo: reg bwght cigs
estadd ysumm 
eststo: reg bwght cigs lfaminc
estadd ysumm 
eststo: reg bwght cigs lfaminc fatheduc motheduc 
estadd ysumm 
eststo: reg bwght cigs lfaminc fatheduc motheduc male parity white
estadd ysumm 

label var cigs "Cigs smoked per day"
label var lfaminc "Ln(family income)"
label var fatheduc "Father education"
label var motheduc "Mother education"
label var male "Male infant"
label var parity "Parity"
label var white "White"

* This line is to show the table in the log 
esttab, se(3) b(3) r2 label nocons stats(ymean r2 N, fmt(2 %9.3fc %9.0fc) label("Outcome mean" "R-squared" "Observations")) nomtitle replace title("Effects of cigarettes on birthweight") /// 
            addnote("Outcome in all specifications is birthweight in ounces.")

esttab using b.html, se(3) b(3) r2 label nocons stats(ymean r2 N, fmt(2 %9.3fc %9.0fc) label("Outcome mean" "R-squared" "Observations")) nomtitle replace title("Effects of cigarettes on birthweight") /// 
            addnote("Outcome in all specifications is birthweight in ounces.")
			
log close  
