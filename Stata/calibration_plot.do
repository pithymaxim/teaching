clear
bcuse loanapp

gen train = runiform()<0.50

logit married dep-gift if train==1
predict married_hat 

keep if train==0

gquantiles married_hat_dec = married_hat, nq(10) xtile

collapse (mean) married married_hat, by(married_hat_dec)

twoway (scatter married married_hat)  ///
       (function y = x), graphregion(color(white)) ///
	   legend(off) ytitle(Share married) xtitle(Predicted probability married)
