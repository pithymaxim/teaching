# LaLonde NSW data

This page contains data from the National Supported Work Demonstration and the PSID. Write-up of the NSW is [here](https://www.mdrc.org/work/publications/summary-and-findings-national-supported-work-demonstration).

# nsw_experiment.dta

A data frame with 445 observations, corresponding to 185 treated and 260 control subjects, and 10 variables. The treatment assignment indicator is the first variable of the data frame: treatment (1 = treated; 0 = control). The next 7 columns are the covariates: 
- "treat" is the treatment assignment (1=treated, 0=control).
- "age" is age in years.
- "educ" is education in number of years of schooling.
- "race" is the individual’s race/ethnicity, (Black, Hispanic, or White). Note previous versions
of this dataset used indicator variables black and hispan instead of a single race variable.
- "married" is an indicator for married (1=married, 0=not married).
- "nodegree" is an indicator for whether the individual has a high school degree (1=no degree,
0=degree).
- "re74" is income in 1974, in U.S. dollars.
- "re75" is income in 1975, in U.S. dollars.
- "re78" is income in 1978, in U.S. dollars.
- "treat" is the treatment variable, "re78" is the outcome, and the others are pre-treatment covariates

More [here](https://search.r-project.org/CRAN/refmans/designmatch/html/lalonde.html)

# psid_with_treated.dta 

This contains 2,675 observations: 2,490 controls from the PSID and 185 participants in the work training program. Same variable definitions as above. Regressing `re78` on `treat` gives the same results as Table 3 Column (1), row "PSID-1" of [Dehejia and Wahba (1999)](https://www.jstor.org/stable/2669919). 
