bcuse loanapp, clear
gen test= runiform() < .50

global features1 emp dep married
global features2 emp dep married appinc loanamt unit
global features3 emp dep married appinc loanamt unit pubrec multi self liq lines mortg

forvalues i=1/3 {
	logit approve ${features`i'} if test==0
	predict phat`i'
	estat classification
}

roccomp approve phat1 phat2 phat3  if test==1,  /// 
       graph  plot1opts(msize(tiny) lw(vthin)) /// 
	          plot2opts(msize(tiny) lw(vthin)) /// 
	          plot3opts(msize(tiny) lw(vthin)) ///
			  graphregion(color(white)) ///
			  xtitle(False positive rate) ytitle(True positive rate)

roccomp approve phat1 phat2 phat3 if test==1
