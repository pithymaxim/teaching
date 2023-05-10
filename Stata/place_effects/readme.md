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
