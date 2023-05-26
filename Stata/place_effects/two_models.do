sysuse auto, clear 
 
* Extract car company name 
split make, gen(m) parse(" ") 
rename m1 company 
 
* Make string company into numeric company_id. 
encode company, gen(company_id) // AMC, Buick, Volvo, etc.

eststo m1: regress price ib4.company_id, robust	
eststo m2: regress price ib4.company_id mpg foreign, robust	

coefplot (m1, color(blue%60) ciopts(color(blue%20))) ///
         (m2, color(red%60) ciopts(color(red%20))), sort keep(*.company_id) graphregion(color(white)) ///
                legend(position(3) ring(0) order(2 "Raw estimates" 4 "With controls") rows(2)) ///
				xline(0) xtitle(Effect on price) xlabel(,format(%15.0fc))
				
				
