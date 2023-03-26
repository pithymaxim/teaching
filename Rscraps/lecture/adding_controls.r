# Read in the data from a Stata file
data(wagepan)

# Keep only observations from 1987
wagepan <- wagepan[wagepan$year == 1987,]

# # Drop variables d81-d87
# wagepan <- wagepan[, !(names(wagepan) %in% paste0("d", 81:87))]

# Create a variable exper_sq equal to exper squared
wagepan$exper_sq <- wagepan$exper^2

# Create a dummy variable high_school_plus indicating whether educ >= 12
wagepan$high_school_plus <- as.numeric(wagepan$educ >= 12)

# Model 1: regress lwageon married
est1 <- lm(lwage~ married, data = wagepan)

# Model 2: regress lwageon married, black, and hisp
est2 <- lm(lwage~ married + black + hisp, data = wagepan)

# Model 3: regress lwageon married, black, hisp, exper, educ, exper_sq, and high_school_plus
est3 <- lm(lwage~ married + black + hisp + exper + educ + exper_sq + high_school_plus, data = wagepan)

# Model 4: regress lwageon married, black, hisp, exper, educ, exper_sq, high_school_plus, occ* and union
est4 <- lm(lwage~ married + black + hisp + exper + educ + exper_sq + high_school_plus + union + 
                    occ1 + occ2 + occ3 + occ4 + occ5 + occ6 + occ7 + occ8 , data = wagepan)

stargazer(est1, est2, est3, est4, type="text")
