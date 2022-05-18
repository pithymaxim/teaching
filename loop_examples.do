*--------------------------- Loop over numbers 
sysuse auto, clear 

forvalues i = 2/5 {
	display "On number: `i'"
	gen price`i' = price^`i'
}

* Check if it worked
list price* in 1/10

forvalues i = 1000(1000)10000 {
	display "On number `i'"
	gen price_over_`i' = price > `i'
}

* Check if it worked
sum price_over* 

*--------------------------- Loop over variables 
sysuse auto, clear 

foreach var of varlist price mpg trunk {
	display "On this variable `var'"
	sum `var'
	gen `var'_over_mean = `var' > r(mean)
}

* Check if it worked
sum *_over_mean 

*--------------------------- Loop over strings
sysuse auto, clear 
gen animal=0
foreach s in bird fox bobcat colt {
	display "Searching for `s'"
	replace animal=1 if strpos(lower(make),"`s'")>0
}

* Check if it worked
tab make if animal==1
