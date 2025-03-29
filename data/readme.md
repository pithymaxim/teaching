# benefits 

from https://rdrr.io/cran/wooldridge/man/benefits.html

# nba_player_datasetsICR.csv # 

Is from https://search.r-project.org/CRAN/refmans/datasetsICR/html/NBA.game.html

# caschool.csv #

| Variable | Description |
|----------|-------------|
| `distcode` | District code |
| `county` | Name of county |
| `district` | Name of district |
| `grspan` | Grade span of district |
| `enrltot` | Total enrollment |
| `teachers` | Number of teachers |
| `calwpct` | Percent qualifying for CalWorks |
| `mealpct` | Percent qualifying for reduced-price lunch |
| `computer` | Number of computers |
| `testscr` | Average test score (reading + math)/2 |
| `compstu` | Number of computers per student |
| `expnstu` | Expenditure per student |
| `str` | Student-to-teacher ratio |
| `avginc` | District average income |
| `elpct` | Percent of English learners |
| `readscr` | Average reading score |
| `mathscr` | Average math score |


# County level extract #

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

# Dog breeds # 

From https://github.com/tmfilho/akcdata
