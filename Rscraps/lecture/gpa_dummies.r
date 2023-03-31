library(wooldridge)

data(attend)
attend$gpa_under2 = as.numeric(attend$priGPA < 2)
attend$gpa_2to3 =   as.numeric(attend$priGPA >= 2 & attend$priGPA < 3)
attend$gpa_3plus =  as.numeric(attend$priGPA >= 3)

# Bad regression
summary(lm(attend ~ gpa_under2 + gpa_2to3 + gpa_3plus, data = attend))

head(attend[c("priGPA","gpa_under2","gpa_2to3","gpa_3plus")])

# Dropping the redundant dummy 
summary(lm(formula = attend ~ gpa_2to3 + gpa_3plus, data = attend))

# Checking against raw subgroup means
mean(attend$attend[attend$gpa_under2==1])
mean(attend$attend[attend$gpa_2to3==1])
mean(attend$attend[attend$gpa_3plus==1])
