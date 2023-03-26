/*
Author: Dr. P. Value
Date: 3/26/2021
Purpose: Worksheet 1
*/
cd C:\Users\Class\Worksheet1 
set more off
cap log close 
log using example_worksheet_dofile.log, replace 
 
***************************************************
*** Q1 ********************************************
***************************************************
sysuse auto, clear
** (a)
regress price mpg
display "Response in price to 3 more miles per gallon: " _b[mpg]*3
 
** (b)
* Calculate share of cars that are foreign
sum foreign
 
***************************************************
*** Q2 ********************************************
***************************************************
bcuse recid, clear 
 
** (a)
* Count number of observations
count 
 
 
log close 
