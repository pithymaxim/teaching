# atus_MN4111.dta

Build from an IPUMS ATUS-X pull. Dofiles in `scripts/`. All variables from IPUMS except
```
too_little_sleep = sleeping/60 < 6
any_kids = childcare>0
```

# benefits 

from https://rdrr.io/cran/wooldridge/man/benefits.html

# nba_player_datasetsICR.csv # 

Is from https://search.r-project.org/CRAN/refmans/datasetsICR/html/NBA.game.html

# caschool.csv #

| Variable | Description |
|----------|-------------|
| `dist_cod` | District code |
| `county` | Name of county |
| `district` | Name of district |
| `gr_span` | Grade span of district |
| `enrl_tot` | Total enrollment |
| `teachers` | Number of teachers |
| `calw_pct` | Percent qualifying for CalWorks |
| `meal_pct` | Percent qualifying for reduced-price lunch |
| `computer` | Number of computers |
| `testscr` | Average test score (reading + math)/2 |
| `comp_stu` | Number of computers per student |
| `expn_stu` | Expenditure per student |
| `str` | Student-to-teacher ratio |
| `avginc` | District average income |
| `el_pct` | Percent of English learners |
| `read_scr` | Average reading score |
| `math_scr` | Average math score |


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

# NHEFS #

This is cleaned data from the National Health and Nutrition Examination Survey Data I Epidemiologic Follow-up Study provided in Hernan and Robins' book [_What if_](https://miguelhernan.org/whatifbook). Codebook available [here](https://github.com/BiomedSciAI/causallib/blob/master/causallib/datasets/data/nhefs/NHEFS_codebook.csv). N = 1,629.
