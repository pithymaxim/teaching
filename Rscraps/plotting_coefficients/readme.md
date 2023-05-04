# How to plot coefficients from regressions in R # 

The `plot_summs()` command seems the best for plotting coefficients in R. See [here](https://jtools.jacob-long.com/reference/plot_summs.html) for documentation. The full code for this example is [here](https://github.com/pithymaxim/teaching/blob/main/Rscraps/plotting_coefficients/plot_summs_example.r). 

Let's say we are interested in the affect of previous alcohol or drug arrests on recidivism for a sample of released inmates (this is the `recid` data from the `wooldridge` package). We run three models: two LPMs and a logit with the same controls as the 2nd LPM. Instead of using log odds coefficients, we calculate the marginal effects from the logit.

```R
mod1 = lm(arrested ~ alcohol + drugs, data = recid)
mod2 = lm(arrested ~ alcohol + drugs + priors + age + tserved + married, data = recid)

logit = glm(arrested ~ alcohol + drugs + priors + age + tserved + married,
             data = recid, family = binomial())
mod3 = margins(logit, type = "response")
```

The `plot_summs()` command can make this plot:

![image](https://user-images.githubusercontent.com/6835110/236272653-68228283-7ea4-4d08-a645-a0d87fdd7ad5.png)

Key syntax: 

- `model.names` is how we give a unique label to the different regressions
- `coefs` does two things: specifies the variables we want to keep _and_ gives them a label (label on the left of the equals sign, original variable name on the right)
