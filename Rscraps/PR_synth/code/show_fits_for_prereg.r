# Wages 
wage_ridge = synth_runner(outcome="avg_wkly_wage_sa", technique="Ridge",treated_jan_2023=T)
cf_plot=augsynth_plots(augsynth_result=wage_ridge$result, prereg=TRUE, include_notes=FALSE,
                       outcome="avg_wkly_wage_sa")

# Employment 
emp_ridge  = synth_runner(outcome="month_emplvl_sa", technique="Ridge", treated_jan_2023=T)
cf_plot=augsynth_plots(augsynth_result=emp_ridge$result, prereg=TRUE, include_notes=FALSE,
                       outcome="month_emplvl_sa")
