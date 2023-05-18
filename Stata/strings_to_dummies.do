sysuse auto, clear

*--------------------------------------------------------------*
**** Make a dummy equal to 1 if the string *********************
**** variable contains certain characters  *********************
*--------------------------------------------------------------*
gen vw = strpos(make,"VW")>0 

* Tab shows that there are 4 instances of 1
tab vw 

* Confirm that it did the right thing
tab make if vw==1

*--------------------------------------------------------------*
**** Can combine with boolean operators like "or" ( | ) *******
*--------------------------------------------------------------*
gen vw_or_toyota = strpos(make,"VW")>0 | strpos(make,"Toyota")>0

* Confirm that it did the right thing
tab make if vw_or_toyota==1

*--------------------------------------------------------------*
****  Can also identify specific values with '=='        *******
*--------------------------------------------------------------*
gen celica = make=="Toyota Celica"

* Confirm that it did the right thing
tab make if celica==1

*--------------------------------------------------------------*
****  Now we have numeric dummies based on strings!      *******
*--------------------------------------------------------------*
regress price celica vw vw_or_toyota

*--------------------------------------------------------------*
****  Split up a string variable                         *******
*--------------------------------------------------------------*
split make, gen(splitvars) parse(" ") 
rename splitvars1 company 

* Confirm that it worked
tab company 

*--------------------------------------------------------------*
****  Encode a string variable                           *******
*--------------------------------------------------------------*
* This doesn't work! 
capture noisily regress price i.company

* "encode" can make a string variable into a numeric variable
* (note: can't have too many unique values)
encode company, gen(company_id) 

* Now we have a numeric version of company 
describe company company_id

regress price i.company_id 

* company_id is a NUMERIC variable, but with VALUE LABELS
list company_id in 1/10
list company_id in 1/10, nolab // this list command shows it with no labels 

