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
- Most importantly, everything works just the same if we add control variables, for example below we add controls for weight and trunkL
```
regress price i.company_id weight trunk, robust 
```

## Testing for significant place effects

After the regression, we can also test if the place effects are jointly significant with this command:
```
testparm i.company_id
```
This is a joint F-test on all of the place fixed effects. High p-values mean that we cannot reject that all of the place effects are equal to zero. We can think about this as testing whether there are any place effects in our context.

## Plotting place effects
You can run this `coefplot` command after your regression to visualize your estimated place effects:
```
coefplot, sort keep(*.company_id) graphregion(color(white))
```


