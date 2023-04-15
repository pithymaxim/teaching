insheet using https://github.com/pithymaxim/teaching/raw/main/data/micro_panel.csv, comma names clear

gen log_income = log(incomethousands)

eststo clear
eststo: regress log_income married
eststo: regress log_income married i.year
eststo: regress log_income married i.year, absorb(name)

esttab *, se(3) b(3) nocons keep(married) ///
		  mtitle("No controls" "Time FEs" "TWFE") replace
