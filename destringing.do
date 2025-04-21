use "https://github.com/pithymaxim/teaching/raw/refs/heads/main/data/cwbh_extract.dta", clear

*--------------------------------------------- Destringing 
* This doesn't work!
hist total_weeks_claimed
sum total_weeks_claimed

* Weird...it looks OK:
list total_weeks_claimed in 1/10

* Ah: it's stored as a string
describe total_weeks_claimed

* Error message here because there are non-numeric characters
destring total_weeks_claimed, replace

* Investigate:
tab total_weeks_claimed if real(total_weeks_claimed)==.

* The asterisks (*) are the problem values
replace total_weeks_claimed = "" if total_weeks_claimed=="*"

* This works!
destring total_weeks_claimed, replace

* This now works
hist total_weeks_claimed
sum total_weeks_claimed

*--------------------------------------------- Recoding missing values
hist birth_year
replace birth_year = . if birth_year==99
hist birth_year
