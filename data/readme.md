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

# FYLCdata.dta

This is the replication data from [Do learning communities increase first year college retention? Evidence from a randomized control trial](https://www.sciencedirect.com/science/article/pii/S0272775722000553#ecom0002) by Azzam et al.

## Variable descriptions

| Variable Name | Description |
|---------------|-------------|
| **Treatment Variables** |  |
| `Assigned_rct` | Treatment assignment variable (randomized) |
| `FYLC` | Treatment uptake variable (First-Year Learning Community participation) |
| **Outcome Variables** |  |
| `Retention_After_Year_1` | Student retention after first year (binary) |
| `GPAyr1` | First-year grade point average |
| `GPAyr2` | Second-year grade point average |
| **Covariates** |  |
| `Cohort` | Student cohort/year |
| `Gender` | Student gender |
| `Highschool_GPA` | High school grade point average |
| `Cen_HSGPA` | Centered high school GPA (standardized) |
| `SAT_Verbal` | SAT verbal score |
| `Cen_SAT_Verbal` | Centered SAT verbal score (standardized) |
| `SAT_Math` | SAT math score |
| `Cen_SAT_Math` | Centered SAT math score (standardized) |
| `SAT_Writing` | SAT writing score |
| `Cen_SAT_writing` | Centered SAT writing score (standardized) |
| `Low_Income` | Low income status indicator |
| `FIRSTGEN` | First generation college student indicator |
| `ON_CAMPUS` | On-campus housing indicator |
| **Other Variables** |  |
| `RCT` | Indicates participation in the randomized controlled trial |
| `non_experimental` | Indicates non-experimental sample |

# NHEFS #

This is cleaned data from the National Health and Nutrition Examination Survey Data I Epidemiologic Follow-up Study provided in Hernan and Robins' book [_What if_](https://miguelhernan.org/whatifbook). Codebook available [here](https://github.com/BiomedSciAI/causallib/blob/master/causallib/datasets/data/nhefs/NHEFS_codebook.csv). N = 1,629.
