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
       Cad.  |   7855.048   1622.314     4.84   0.000     4598.117    11111.98
      Chev.  |  -1702.952   1035.935    -1.64   0.106    -3782.678    376.7737
     Datsun  |  -68.78571   1256.607    -0.05   0.957     -2591.53    2453.958
      Dodge  |  -1019.786   1149.646    -0.89   0.379    -3327.797    1288.225
       Fiat  |  -1779.286    951.735    -1.87   0.067    -3689.973    131.4019
       Ford  |  -1787.286   955.6151    -1.87   0.067    -3705.763    131.1916
      Honda  |  -926.2857   1101.054    -0.84   0.404    -3136.743    1284.172
      Linc.  |   6777.048   1162.474     5.83   0.000     4443.285    9110.811
      Mazda  |  -2080.286    951.735    -2.19   0.033    -3990.973   -169.5981
      Merc.  |  -1161.452   1102.431    -1.05   0.297    -3374.675     1051.77
       Olds  |  -24.42857   1415.725    -0.02   0.986    -2866.615    2817.758
    Peugeot  |   6914.714    951.735     7.27   0.000     5004.027    8825.402
      Plym.  |  -1255.286   1057.278    -1.19   0.241     -3377.86    867.2889
      Pont.  |  -1196.452   987.0029    -1.21   0.231    -3177.943    785.0386
    Renault  |  -2180.286    951.735    -2.29   0.026    -4090.973   -269.5981
     Subaru  |  -2277.286    951.735    -2.39   0.020    -4187.973   -366.5981
     Toyota  |  -953.2857   1168.313    -0.82   0.418    -3298.773    1392.201
         VW  |  -54.28571   1129.583    -0.05   0.962    -2322.019    2213.447
      Volvo  |   5919.714    951.735     6.22   0.000     4009.027    7830.402
             |
       _cons |   6075.286    951.735     6.38   0.000     4164.598    7985.973
------------------------------------------------------------------------------
```
Notes:
- The omitted company here is Buick. So any t-stat is testing the hypothesis that the company in question differs from Buick! 
- If we want to test for differences between two specific companies, we would run ``` test 1.company_id=2.company_id
```

## Testing for significant place effects

After the regression, we can test if the place effects are jointly significant with this command:
```
testparm i.company_id
```
This is a joint F-test on all of the place fixed effects. High p-values mean that we cannot reject that all of the place effects are equal to zero. 




