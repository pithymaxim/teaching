cd D:\atus

use atus_00035.dta, clear

gen less_than_high_school = educyrs<112
gen high_school = educyrs== 112 
gen college = inrange(educyrs,213,217)
gen graduate_degree = educyrs >= 316

gen age_5yr = floor(age/5)*5

gen weekend = inlist(day,1,7)

gegen weight_cell = group(weekend race hispan sex nchild less_than_high_school-graduate_degree age_5yr)

gen childcare = duration if inrange(activity,030000,030399) | inrange(activity,180301,180303) | ///
							inrange(activity,180401,180404) | activity==180801 | ///
							inrange(activity,040000,040299) // non-hh kids 
gen sleeping = duration if inrange(activity,010100,010199)
gen housework = duration if inrange(activity,020100,020299)
gen work = duration if inrange(activity,050000,059999)
gen education = duration if inrange(activity,060000,069999)
gen shopping = duration if inrange(activity,070000,079999)
gen relaxing = duration if inrange(activity,120300,129999)

gen at_home = duration if  where== 101 	
	
collapse (firstnm) famincome vetstat weight_cell month less_than_high_school high_school college graduate_degree  year day  citizen empstat statefip wt06  age sex   marst  race hispan metro (rawsum) at_home childcare sleeping housework work education shopping relaxing, by(caseid)

gen too_little_sleep = sleeping/60 < 6
sum too_little_sleep
gen any_kids = childcare>0

regress too_little_sleep any_kids sex

sample 25000, count
compress 
save atus_MN4111.dta, replace
