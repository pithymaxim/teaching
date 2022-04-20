sysuse auto, clear

global myvars weight headroom trunk mpg price
global mysplitvar foreign

eststo group1_means: estpost summarize $myvars if $mysplitvar == 0
eststo group2_means: estpost summarize $myvars if $mysplitvar == 1
eststo differences:  estpost ttest $myvars, by($mysplitvar) unequal

*** Make HTML table
esttab group1_means group2_means differences using balance.html, replace ///
    cell( mean(pattern(1 1 0) fmt(2))     &  b(pattern(0 0 1) fmt(2) star) ///
            sd(pattern(1 1 0) fmt(2) par) & se(pattern(0 0 1) fmt(2) par)) ///
	mtitle("Domestic cars" "Foreign cars" "Difference (1)-(2)") label  collabels(none) ///
	starlevels(* .10 ** .05 *** .01)  /// 
	refcat(weight " <strong>  Physical features </strong> <br>"  ///
	mpg "<strong>  Important features </strong> <br>", label(" ") ) /// 
	addnote("Columns (1) and (2) show means, with standard deviations in parentheses. Column (3) shows the difference in means, with the standard error of the difference in parentheses and with stars specifiying significance as follows: * for p<.10, ** for p<.05, *** for p<.01.") 

*** Make .rtf table 
esttab group1_means group2_means differences using balance.rtf, replace ///
    cell( mean(pattern(1 1 0) fmt(2))     &  b(pattern(0 0 1) fmt(2) star) ///
            sd(pattern(1 1 0) fmt(2) par) & se(pattern(0 0 1) fmt(2) par)) ///
	mtitle("Domestic cars" "Foreign cars" "Difference (1)-(2)") label  collabels(none) ///
	starlevels(* .10 ** .05 *** .01)  /// 
	refcat(weight " {\b Physical features}"  ///
           mpg " {\b Important features}", label(" ") ) /// 
	addnote("Columns (1) and (2) show means, with standard deviations in parentheses. Column (3) shows the difference in means, with the standard error of the difference in parentheses and with stars specifiying significance as follows: * for p<.10, ** for p<.05, *** for p<.01.") 
