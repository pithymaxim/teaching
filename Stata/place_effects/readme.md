# Place effects in Stata

Many papers in economics are about stable geographic difference in outcomes across places. For an example, check out: [Place-Based Drivers of Mortality: Evidence from Migration](https://www.aeaweb.org/articles?id=10.1257/aer.20190825). They show that mortality rates differ a lot across different metropolitan areas in the US, and that some of this appears to be causal because people who move to high-longevity areas tend to live longer.

The core objects of interest in these analyses are "place effects." The simplest possible version of this is to write it out as follows:

$$
Y_{ip} = \Theta_p + e_{ip}
$$

This says the the outcome (e.g., BMI or medical spending) of person $i$ who lives in place $p$ is a function just of the place effect where they live $\Theta_p$ and an error term $e_{ip}$. This is equivalent to simply calculating the place-level means.

But this can be extended to include controls. 

$$
Y_{ip} = \Theta_p  + X_{ip}' \beta + e_{ip}
$$

Here we add $X_{ip}$, a set of controls including, say, age and race. $\beta$ is the set of coefficients on those controls. In this case, the place effects could change. They could shrink a lot if much of the variation in place level means was driven by selection. But these estimates are viewed as more likely to be causal, because now we're controlling for the traits of people who live there. So a major check in any place effects analysis is how much the distribution shrinks (or grows) with the addition of controls.

## Estimating simple place effects in Stata 

Here's a demonstration on how to estimate place effects with and without controls. We use the auto dataset in Stata. The car company is the "place" here.

```
sysuse auto, clear 
 
* Extract car company name 
split make, gen(m) parse(" ") 
rename m1 company 
 
* Make string company into numeric company_id. 
encode company, gen(company_id) // AMC, Buick, Volvo, etc.
```

Then we can estimate a place effects regression as follows:
```
. eststo: regress price ib4.company_id, robust

Linear regression                               Number of obs     =         74
                                                F(15, 51)         =          .
                                                Prob > F          =          .
                                                R-squared         =     0.8042
                                                Root MSE          =     1561.7

------------------------------------------------------------------------------
             |               Robust
       price | Coefficient  std. err.      t    P>|t|     [95% conf. interval]
-------------+----------------------------------------------------------------
  company_id |
        AMC  |  -1859.619   990.8792    -1.88   0.066    -3848.892    129.6539
       Audi  |   1917.214   1730.984     1.11   0.273     -1557.88    5392.309
        BMW  |   3659.714    951.735     3.85   0.000     1749.027    5570.402
... (output omitted)
```
Notes:
- The omitted company here is Buick. So any t-stat is testing the hypothesis that the company in question differs from Buick! Make sure you know what your omitted place here. I chose Buick because it's one of the biggest categories.
- If we want to test for differences between two specific companies for example whether the place effect for company 1 (AMC) is significantly different from the place effect for company 2 (Audi), we would run 
``` 
test 1.company_id=2.company_id
```
- Most importantly, everything works just the same if we add control variables, for example below we add controls for weight and trunk:
```
regress price i.company_id weight trunk, robust 
```

## Testing for significant place effects

After the regression, we can also test if the place effects are jointly significant with this command:
```
testparm i.company_id
```
This is a joint F-test on all of the place fixed effects. High p-values mean that we cannot reject that all of the place effects are equal to zero. We can think about this as testing whether there are any place effects in our context. In this context, we can reject that all company effects are zero:

```
       F( 16,    51) =   20.72
            Prob > F =    0.0000
```

## Plotting place effects
You can run this `coefplot` command after your regression to visualize your estimated place effects:
```
coefplot, sort keep(*.company_id) graphregion(color(white))
```
It makes this plot:
![image](https://github.com/pithymaxim/teaching/assets/6835110/2fcccfa2-ce91-4119-9cc6-97557f6b41eb)

## Analyzing results with and without controls 

The `reghdfe` command provides a more flexible way to work with fixed effect estimates. Here we estimate the same fixed effects regressions but save the estimated fixed effects in columns called "company_FE" and "company_FE_controls" using `reghdfe`'s `absorb` option.
```
reghdfe price,                                              absorb(company_FE=company_id) vce(robust)
reghdfe price weight trunk foreign mpg turn headroom rep78, absorb(company_FE_controls=company_id) vce(robust)
```
Now, how do the fixed effects change with controls? First we keep just one observation per company. Then we can see how the standard deviation of the fixed effects changes:
```
bys company_id: keep if _n==1
sum company_FE company_FE_controls
    Variable |        Obs        Mean    Std. dev.       Min        Max
-------------+---------------------------------------------------------
  company_FE |         16    306.3866    2906.794  -1836.945   7877.721
company_FE~s |         15    464.6463    2254.764  -1823.572   6196.286
```
The standard deviation gets somewhat smaller with the controls, decreasing from 2.9k to 2.2k. A histogram shows the slight scrunching of the distribution too.
```
twoway (hist company_FE         , color(red%20) width(500))  ///   
       (hist company_FE_controls, color(green%20) width(500)), ///
	   legend(order(1 "No controls" 2 "With controls")) xtitle(Estimated company fixed effect)
```
![image](https://github.com/pithymaxim/teaching/assets/6835110/64e2b80b-ae2f-40e7-a8de-b08d5c48e057)

# Place effects in a more realistic context

A more realistic question is: What is the effect on wages that you get merely by working in a different industry? For example, imagine a mall janitor that gets hired to do the same work at a large technology firm. Will they be paid more after this switch? [`sipp_industry_effects.dta`](https://github.com/pithymaxim/teaching/blob/main/data/sipp_industry_effects.dta) allows you to analyze such a question. It contains data on workers in the SIPP. This is panel data, with one row representing a person's responses for that particular month. Some people switch industries during the sample period.

## How many switchers?

We're going to want to include person fixed effects, and for this we need at least some people to switch industries. 

How many switchers do we have? Since there's a numeric code for industry, we can count this by identifying people whose maximum value of industry is different from their minimum value of industry. This could only happen if they changed industries at some point (everyone in the sample is always employed).
```
bys id: egen max_ind = max(industry)
bys id: egen min_ind = min(industry)
gen my_switcher_measure = max_ind!=min_ind
```
Anyone with `max_ind` not equal to `min_ind` is someone who changed industries at some point. To count them, we first make a variable equal to one for that person's first observation (otherwise we would county every row they appear in the data)
```
bys id: gen first_obs = _n==1
```
Now we can properly count them:
```
. tab switcher if first_obs==1

switcher_or |
         ig |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        705       71.21       71.21
          1 |        285       28.79      100.00
------------+-----------------------------------
      Total |        990      100.00
```
Out of 990 unique people, 285 switched industries.

## Estimating industry effects

Next, we can estimate similar regressions with and without controls. I make the reference industry durable manufacturing since that's the biggest one in this data. Note that time controls should always be included.
```
eststo m1: regress earnings ib5.industry i.year i.month, cluster(id)
eststo m2: regress earnings ib5.industry i.year i.month hours age uniond, cluster(id) absorb(id)
```
Ultimately, the large confidence intervals on the point estimates below suggest that we are underpowered to detect reasonable industry effects. 285 switchers is too small of a sample for the kind of analysis that we're doing. It still captures some interesting things though. For example, people working in personal services (house cleaners, barbers, etc.) are doing way worse than all other industries when you look at the raw averages (top blue dot). However, once you account for hours, age, union membership and---most importantly---person fixed effects, personal services look a lot less bad (top red dot). This suggests that most of the gap in raw earnings was due to the fact that people working in personal services also tend to end less in other industries.

![image](https://github.com/user-attachments/assets/5a51d9ea-6ef3-47ef-a370-2cff85479013)

