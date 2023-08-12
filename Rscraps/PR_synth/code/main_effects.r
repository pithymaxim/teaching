# === Primary estimates

# Effects on employment and wages, augmented with Ridge
emp_ridge  = synth_runner(outcome="month_emplvl_sa", technique="Ridge")
wage_ridge = synth_runner(outcome="avg_wkly_wage_sa", technique="Ridge")

# === Secondary estimates

# (code to come)

# === Robustness checks 
# Non-bordering
emp_ridge  = synth_runner(outcome="month_emplvl_sa", technique="Ridge",remove_border_states = T)
wage_ridge = synth_runner(outcome="avg_wkly_wage_sa", technique="Ridge",remove_border_states = T)

# GSYNTH
emp_ridge  = synth_runner(outcome="month_emplvl_sa", technique="GSYN")
wage_ridge = synth_runner(outcome="avg_wkly_wage_sa", technique="GSYN")

# Vanilla synthetic control
emp_ridge  = synth_runner(outcome="month_emplvl_sa", progfunc="none")
wage_ridge = synth_runner(outcome="avg_wkly_wage_sa", progfunc="none")

# Earlier treatment date
emp_ridge  = synth_runner(outcome="month_emplvl_sa", technique="Ridge", treated_jan_2023=T)
wage_ridge = synth_runner(outcome="avg_wkly_wage_sa", technique="Ridge", treated_jan_2023=T)
