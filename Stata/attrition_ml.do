use "Army.dta", clear 

duplicates drop 

gen month = month(acc_dt)
gen day = day(acc_dt)
gen early_attrite = tis < 36 

gen test = runiform() > 0.50
lasso logit early_attrite afqt accession_date female hs nohi married year month day ed_level if test==0
predict phat

twoway (hist phat if early_attrite==1 & test==1, color(red%30) freq) ///
(hist phat if early_attrite==0 & test==1, color(green%20) freq), ///
legend(order(1 "Attrited Early" 2 "Did not attrite early")) ///
xline(0.4) xline(0.6) graphregion(color(white))
