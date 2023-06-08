eststo clear 
sysuse auto, clear

eststo: regress price mpg i.foreign##i.rep78
estadd local includes_FEs "Yes"

* Drop by hand 
esttab * , drop(1.foreign#1.rep78 1.foreign#2.rep78  1.foreign#5.rep78 0.foreign* 1.rep78) 

* Indicate using "estadd local" code, keep only coefficient of interest
esttab * , keep(mpg) stats(includes_FEs r2 N, label("Has fixed effects for foreign and rep" "R-squared" "N"))        
