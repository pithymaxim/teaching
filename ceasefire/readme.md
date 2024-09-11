# Replicating the Boston Ceasefire study

This provides the code and data for reproducing (in spirit) the main findings from *[Problem-oriented policing, deterrence, and youth violence: An evaluation of Boston's Operation Ceasefire](https://www.d.umn.edu/~jmaahs/Correctional%20Assessment/Articles/Braga_problem_oriented%20policing_deterrence.pdf)* by Braga et al. The authors find that the adoption of [Operation Ceasfire](https://en.wikipedia.org/wiki/Operation_Ceasefire) in Boston was associated with a large drop in juvenile homicides:
![image](https://github.com/user-attachments/assets/422e4059-8003-433f-97d8-fc56b3014886)

# Running the code

This main finding is reproducible with the "Uniform Crime Reports: Supplementary Homicide Reports, 1976-2002" available from ICPSR (download `DS2 Victim Data` at this [link](https://www.icpsr.umich.edu/web/NACJD/studies/4179/versions/V1)).

To run this:

- Put `04179-0002-Data.txt` from the ICPSR [link](https://www.icpsr.umich.edu/web/NACJD/studies/4179/versions/V1) into your `raw/` folder
- Run `import_ucr.do` to load the UCR data into Stata
- Run `build.do` to make the analysis file
  - This is a quicky and dirty build! City-level data is assembled by identifying agencies in the same state with the city name in the agency name. Also, the build treats all missing months as zero, although that's certainly wrong in some cases.
  - You can alter the globals make a monthly or quarterly build
  - This also includes a longer pre-period than the original study
- Run `augsynth_ceasefire.r` to see how the results look using the [augmented synthetic control method](https://arxiv.org/abs/1811.04170).

## Results 

The augsynth (using the quarterly build) finds an Average Post-Treatment Effect of -3.2 (95% CI: -13.0 to 6.9) murders, or a 33% decrease relative to the pre-treatment mean of 9.8 murders per quarter. This is smaller than the original 63% decrease reported in the original paper, but is similar to more conservative estimates reviewed in [Braga et al (2019)](https://scholar.harvard.edu/files/cwinship/files/pulling_levers_skeptic_-_second_edition_update.pdf).

The augsynth script also makes this plot, showing the Boston vs. synthetic Boston. The purple line marks the start of Operation Ceasefire.

![image](https://github.com/user-attachments/assets/52002d80-02ba-4e34-89ec-c2e4340367dc)
