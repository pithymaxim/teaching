do code/city_state_globals.do 

global datevar mdate 
global datevar quarter

global policy_start_mdate = `=mofd(d(1may1996))'
global policy_start_quarter = `=qofd(d(1may1996))'

global orig_list Albuquerque Atlanta Austin Baltimore Boston Charlotte Chicago Cleveland Columbus Dallas Denver Detroit El_Paso Fort_Worth Fresno Honolulu Houston Indianapolis Jacksonville Kansas_City Los_Angeles Long_Beach Memphis Milwaukee Nashville New_York Oakland Oklahoma_City Philadelphia Phoenix Portland San_Antonio San_Diego San_Francisco San_Jose Seattle St_Louis Tucson Tulsa Virginia_Beach

* ================================================

use inter/ucr_import.dta, clear 
gen keep = 0
gen city = ""
* Original cities
foreach city in $orig_list  {
	di "`city' , ${`city'_st}"
	local loop_city = upper(subinstr("`city'","_"," ",.))
	replace keep = 1 if strpos(agname,"`loop_city'")>0 & stcode=="${`city'_st}"
	replace city = "`loop_city'" if strpos(agname,"`loop_city'")>0
}

tab keep

drop if missing(city)

* Keep only juvenile murders 
keep if vicage <= 24 

gen mdate = mofd(mdy(month,1,year))

* Define treatment 
gen treated = city=="BOSTON" & (mdate > mofd(mdy(5,1,1996))) 

gen quarter = qofd(dofm(mdate))
format quarter %tq 

gcollapse (firstnm) treated (count) murders=stnumber, by(city ${datevar})

encode city, gen(city_num)

tsset ${datevar} city_num

tsfill, full

replace murders = 0 if missing(murders)
replace treated = 0 if missing(treated) & city!="BOSTON"

keep city_num treated murders ${datevar}
mdesc

if ("$datevar"=="quarter") gen date = dofq(quarter)
if ("$datevar"=="mdate") gen date = dofm(mdate)

if ("$datevar"!="year") gen year = year(date)
if ("$datevar"=="year") gen date = mdy(1,1,year)

local yearvar year 
if ("$datevar"=="year") local yearvar ""
 
collapse (firstnm) `yearvar' date (sum) murders (max) treated, by(city_num $datevar)

bys city_num: gegen ever_treated = max(treated)

sum murders if ever_treated==1 & treated==0

* Ceasefire stopped around 2001
keep if year < 2002

label data "Made in build.do on ${S_DATE} by `c(username)'"
save inter/ceasefire_balanced_${datevar}.dta, replace


