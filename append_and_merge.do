*** Append data *************
use dads.dta, clear 
append using kids.dta
sort famid kid 
list 
*** Append kids_string_inc.dta 
use kids_string_inc.dta, clear 
replace inc = subinstr(inc,"$","",.)
destring inc, replace 
label data "Made from kids_string_inc.dta on ${S_DATE}"
save kids_string_inc_edited.dta, replace 

use dads.dta, clear 
append using kids_string_inc_edited.dta
sort famid kid 

*** Merge data *************

** 1:1 merge 
use kids.dta, clear 
rename inc kid_inc 
tempfile kids_tmp 
save `kids_tmp', replace 

use dads.dta, clear 
merge 1:1 famid using `kids_tmp'

*** 1:m or m:1 merge
use kids_mult.dta, clear 

use dads.dta, clear 
merge 1:m famid using kids_mult.dta 
