/*
Example of using the stcox command 
to show survival curves with and without controls 
as in Fig 3 of "Association of Prehospital Blood 
Product Transfusion During Medical Evacuation of 
Combat Casualties in Afghanistan With Acute and 
30-Day Survival" by Shackelford et al
https://jamanetwork.com/journals/jama/fullarticle/2658323
*/

* Load data
use army.dta, clear

* Indicate survival structure to Stata
stset tis, failure(separated)

**** Estimate Cox model with no controls 
stcox married
* Save coefficient 
local married1 : di %4.3f exp(_b[married]) 
* Make plot 
stcurve, survival at(married=1) at(married=0) nodraw name(s1, replace) title("Cox survival curve, no controls") note(Married hazard ratio: `married1')

**** Estimate Cox model WITH controls
stcox married age afqt hs postsec female i.year
* Save coefficient 
local married2 : di %4.3f exp(_b[married]) 
* Make plot 
stcurve, survival at(married=1) at(married=0) nodraw name(s2, replace) title("Cox survival curve, with controls") note(Married hazard ratio w/ controls: `married2')
graph combine s1 s2
