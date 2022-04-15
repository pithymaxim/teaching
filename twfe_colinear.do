*******************************************************************************
*** Why can't we include experience with person and time fixed effects? *******
*******************************************************************************

bcuse wagepan, clear

*** Take the average experience for each year
bys year: egen year_mean_exper = mean(exper)
* As expected, this variable is constant within year
tab year, sum(year_mean_exper)

*** Calculate every man's person-level average 
bys nr: egen person_mean_exper = mean(exper)

*** Demean with respect to person
gen demeaned_exper =        exper - person_mean_exper
*** Demean with respect to person AND year 
gen double_demeaned_exper = exper - person_mean_exper - year_mean_exper 

*** Look at some observations for 3 people
sort nr year 
bro nr year exper year_mean_exper person_mean_exper demeaned_exper double_demeaned_exper if inlist(nr,925,13,10091) & inrange(year,1980,1983)
/*
Notice:
	Everyone's person-demeaned experience <demeaned_exper> is the same each year.
	This means that once we subtract the year average <double_demeaned_exper>, there 
	is no variation at all in experience.
	
	This is why <exper> gets dropped out when we include both person AND year fixed effects.
*/
* No variation left. Standard deviation is zero:
sum double_demeaned_exper
