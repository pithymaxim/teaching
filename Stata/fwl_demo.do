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
