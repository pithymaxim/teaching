clear 
set seed 415
set obs 20
gen time=_n 

gen x = 1.5*rnormal() - .1*time
gen y = x + rnormal()*.3 +2

replace y = y + 5*time/15 if time>15

replace time = time + 1970

twoway (connected y x time), ///
       graphregion(color(white)) xtitle("") xline(1985.5) ///
	   text(3 1976 "Group with policy change", size(*1.5)) ///
	   text(-3 1973.5 "No change", size(*1.5)) ylabel(none) legend(off) ///
	   text(7 1982.4 "Policy enacted", size(*1.5))  name(g1, replace) title(Parallel trends, size(*1.5))
graph export "$dropbox\Apps\Overleaf\MN4111\images\parallel_trends.pdf", replace 
	   
clear 
set seed 415
set obs 20
gen time=_n 
	
gen x = .5*rnormal() - .1*time	
gen y = x + .5*rnormal() -.2*time
replace time = time + 1970

twoway (connected y x time), ///
       graphregion(color(white)) xtitle("") xline(1985.5) ///
	   text(.2 1977 "Group with policy change", size(*1.5)) ///
	   text(-3.2 1974 "No change", size(*1.5)) legend(off) ///
	   text(-.2 1988.25 "Policy enacted", size(*1.5)) ylabel(none) name(g2, replace) title(No parallel trends) ///
	   ysc(range(-3.5 1))
	  
graph export "$dropbox\Apps\Overleaf\MN4111\images\no_parallel_trends.pdf", replace 
	   
	   
