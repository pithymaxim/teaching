bcuse bwght, clear 

regress cigs faminc
predict cigs_vs_faminc_residual, resid

regress bwght faminc
predict bwght_vs_faminc_residual, resid

regress bwght_vs_faminc_residual cigs_vs_faminc_residual  
regress bwght cigs faminc 

*** More than one control:
bcuse bwght, clear 

regress cigs faminc parity
predict cigs_vs_faminc_residual, resid

regress bwght faminc parity
predict bwght_vs_faminc_residual, resid

regress bwght_vs_faminc_residual cigs_vs_faminc_residual  
regress bwght cigs faminc parity

* With categorical control

sysuse auto, clear 

regress price mpg 
regress price mpg foreign 

* Demean price 
bys foreign: egen foreign_mean_price = mean(price)
gen price_demeaned = price - foreign_mean_price

*--- Show that demeaning is the same as taking residual 

* Take the residual 
regress price foreign 
predict price_resid_vs_foreign, resid 

* The two are identical 
regress price_demeaned price_resid_vs_foreign

* Demean mpg  
bys foreign: egen foreign_mean_mpg = mean(mpg)
gen mpg_demeaned = mpg - foreign_mean_mpg

* Same coefficients 
regress price_demeaned mpg_demeaned
regress price mpg foreign 
