# Conformal inference #

Steps: 

- **Generate data under the null**: I think this is done by taking $` Y_t(1) - \hat{\theta}_t `$ for $t \geq T0 +1$. In other words, for all of the treated units in the treated periods, subtract from the outcome the estimated treatment effect. This is equivalent to setting their outcome to the counterfactual outcome from the SCM procedure: $Y_t(1) = \sum w_j Y(0)_{tj}$ (note, it might be that actually you just use the actually values $Y_t$ if the null is zero. Still confused about this.)
- **Fit a new SCM under the "null data"**: Use your same SCM algorithm to select weights using the data from the pre-period. Call this new set of weights $\gamma_j$
- **Calculate the residuals from the new SCM**: 
