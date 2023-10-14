# Conformal inference #

Steps: 

- Generate data under the null: I think this is done by taking $` Y_t(1) - \hat{\theta}_t `$ for $t \geq T0 +1$. In other words, for all of the treated units in the treated periods, subtract from the outcome the estimated treatment effect. This is equivalent to setting their outcome to the counterfactual outcome from the SCM procedure: $Y_t(1) = \sum w_j Y(0)_{tj}$ 
