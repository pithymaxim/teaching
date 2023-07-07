clear
input year value group 
2011	0.85320465	1
2012	0.373953753	1
2013	0.357918173	1
2014	0.548973349	1
2011	0.974057572	2
2012	0.201555062	2
2013	0.659306159	2
2014	0.299569525	2
end 

twoway (connected value year if group==1)  (connected value year if group==2), legend(order(1 "Group 1" 2 "Group 2"))
