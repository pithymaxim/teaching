*--------------------------- Loop over numbers 
sysuse auto, clear 

forvalues i = 2/5 {
	display "On number: `i'" // always <indent> the code in the loop. Much easier to read that way.
	gen price`i' = price^`i'
}

* Check if it worked
list price* in 1/10

forvalues j = 1000(1000)10000 { // can use any letter or word instead of i or j
	display "On number `j'"
	gen price_over_`j' = price > `j'
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
	replace animal=1 if strpos(lower(make),"`s'")>0 // note TWO sets of quotes around s! the additional double quotes treat it as a string instead of variable
}

* Check if it worked
tab make if animal==1
