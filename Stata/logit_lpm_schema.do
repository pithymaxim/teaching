clear
set obs 1000
gen x = rnormal(0,2)
gen y = 1 / (1 + exp(-1*(x)))
sort x
regress y x 
predict yhat 
keep if inrange(x,-4,4)
keep if inrange(y,-.1,1.1)
twoway (line y x ) ///
       (line yhat x), /// 
 ytitle("P(y=1)") xtitle(x) yline(1, lc(black)) yline(0, lc(black)) graphregion(color(white)) ///
 legend(order(1 "Logit" 2 "LPM"))
