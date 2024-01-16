* NBA * 

Is from https://search.r-project.org/CRAN/refmans/datasetsICR/html/NBA.game.html

* County level extract * 

is from https://www.kaggle.com/code/johnjdavisiv/us-counties-weather-health-hospitals-covid19-data/report after running this code:
insheet using "US_counties_COVID19_health_weather_data.csv", comma names clear 

gen sdate = date(date,"YMD")
gen mdate = mofd(sdate)

keep if mdate==726
bys fips: keep if _n==1
rename county county_name 
rename fips county 
replace total_population="" if total_population=="NA"
destring total_population, replace 
drop if real(county)==.
destring county, replace 
outsheet using "county_data_extract.csv", comma names replace 
