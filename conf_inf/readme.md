# Conformal inference #

Steps: 

- **Generate data under the null**: I think this is done by taking $` Y_t(1) - \hat{\theta}_t `$ for $t \geq T0 +1$. $\theta_t$ is the treatment effect in period $t$, and $Y_t(1)$ is the actual outcome of the treated group. In other words, for the treated unit in the treated periods, subtract from the outcome the estimated treatment effect. This is equivalent to setting their outcome to the counterfactual outcome from the SCM procedure: $Y_t(1) = \sum w_j Y(0)_{tj}$
  * Note, it might be that actually you just use the actually values $Y_t$ if the null is zero. Still confused about this. Call this confusion A. What's weird is that ``generating data under the null'' when the null is 0 is actually just using the observed outcome data for the treated unit. The blog says "If we postulate the null of no effect, the data under that null means that $Y(0)=Y(1)=Y$, which is just the trajectory of observed outcome we see for the treated state of California." 
- **Fit a new SCM under the "null data"**: Use your same SCM algorithm to select weights using the data from the pre-period _and post period_. Call this new set of weights $\gamma_j$
- **Calculate the residuals from the new SCM**: We can calculate residuals:
$$\hat{u}_t = Y_t - \hat{Y}_t(0)$$
for all time periods $t$. If there was a big positive effect, the residuals should get super negative in the post-period (assuming we use the second option in confusion A).

- **Calculate the test statistic**: this is the sum of the absolute value of residuals in the post-period. For the post-treatment period this is $S(\hat{u_{\pi_0}})$.
- **Calculate the p-value**: We can calculate the test statistic $S$ for every possible permutation of test statistics. Next question: does this mean re-estimating SCM for each permutation? The p-value is then the share of permutations that are bigger than $S(\hat{u_{\pi_0}})$

## Chernozhukov et al explanation ##

![image](https://github.com/pithymaxim/teaching/assets/6835110/ca6b381f-14a7-4ea1-aaa2-5bf2ebde866f)

- $P_t^N$: a mean-unbiased proxy for the counterfactual outcomes of the treated unit in the absense of the policy intervention
- $Y_{1t}^N$:  the counterfactual outcomes of the treated unit in the absense of the policy intervention
- $u_t$: the error
