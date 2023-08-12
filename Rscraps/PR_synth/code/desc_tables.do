cd $dropbox\berkeley\projects\PR_synth
if 1 {
	global overleaf $dropbox\Apps\Overleaf\PR_Synth\exhibits
}

clear 
freduse CPIAUCSL
sum CPIAUCSL if date=="2023-01-01"
gen deflator = CPIAUCSL/r(mean)
rename daten stata_date 
tempfile cpi 
save `cpi', replace 

foreach stub in state  { 
	use inter/temp_only_build_`stub'.dta, clear 	
	gen NJ = state==34 
	drop if year==2023 

	merge m:1 stata_date using `cpi', nogen keep(master match)
	replace avg_wkly_wage = avg_wkly_wage / deflator

	* Label variables 
	label var qtr_emps "Qtr Emps"
	label var total_qtrly_wages "Qtr Wages"
	forvalues i = 1/3 {
		label var month`i'_emplvl "Month `i' Emps"
	}
	label var avg_wkly_wage  "Avg Weekly Wage"
	label var not_disclosed "Not Disclosed"
	label var year "Year"
	
	* Thousands 
	foreach v of varlist month?_emplvl qtr_emps {
	    replace `v' = `v'/1000
		local vv `"`:var label `v''"'
		display "`vv'"
		label var `v' "`vv' (thousands)"
	}
	* Millions  
	foreach v of varlist total_qtrly_wages {
	    replace `v' = `v'/1000
		local vv `"`:var label `v''"'
		display "`vv'"
		label var `v' "`vv' (millions)"
	}
	eststo clear 
	estpost tabstat month?_emplvl qtr_emps total_qtrly_wages avg_wkly_wage not_disclosed year if fake_data==0, ///
		  c(stat) stat(n mean sd min max p25 p50 p75)
	ereturn list 
	#delimit ;
	notetab: esttab using $overleaf/desc_`stub'_level.tex , replace 
	 cells("count(fmt(%20.0fc)) 
		   mean(fmt(%20.2fc %20.2fc %20.2fc %20.2fc %20.2fc %20.2fc %20.2fc   %20.0f)) 
		   sd(fmt(%15.2fc)) 
		   min(fmt(%20.0fc %20.0fc %20.0fc %20.0fc %20.2fc %20.2fc %20.2fc %20.0f)) 
		   max(fmt(%20.0fc %20.0fc %20.0fc %20.0fc %20.2fc %20.2fc %20.2fc %20.0f)) 
		   p25(fmt(%20.0fc %20.0fc %20.0fc %20.0fc %20.2fc %20.2fc %20.2fc %20.0f)) 
		   p50(fmt(%20.0fc %20.0fc %20.0fc %20.0fc %20.2fc %20.2fc %20.2fc %20.0f)) 
		   p75(fmt(%20.0fc %20.0fc %20.0fc %20.0fc %20.2fc %20.2fc %20.2fc %20.0f))") 
	 collabels("N" "Mean" "SD" "Min" "Max" "P25" "P50" "P75")  
	  noobs label nomtitle compress nonumber dofile(desc_tables); 
	#delim cr 
}
 