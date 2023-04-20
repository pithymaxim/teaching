km_split = survfit(Surv(years_of_service,separated) ~  strata(married), data=df)

# Make a dataframe out of the survfit object
n_periods = length(km_split$surv)/2
surv_df = data.frame(survival = km_split$surv, 
                     married =  as.factor(c(rep(0, n_periods), rep(1, n_periods))),
                     time = c(1:n_periods,1:n_periods)/12)

# Now a regular ggplot line can be made using the dataframe
ggplot(surv_df, aes(y=survival,x=time,color=married)) + 
  geom_line() 
