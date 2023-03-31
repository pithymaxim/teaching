library(wooldridge)

data(attend)
attend$gpa_under2 = as.numeric(attend$priGPA < 2)
attend$gpa_2to3 =   as.numeric(attend$priGPA >= 2 & attend$priGPA < 3)
attend$gpa_3plus =  as.numeric(attend$priGPA >= 3)
summary(lm(attend ~ gpa_under2 + gpa_2to3 + gpa_3plus, data = attend))
