* Common issue with tempfiles:
* Need to run the tempfile code all in one go!
sysuse auto, clear 
gen price2 = price^2 

tempfile edited_auto 
save `edited_auto', replace 

use `edited_auto', clear 
