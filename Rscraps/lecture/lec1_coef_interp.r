library(wooldridge)
library(stargazer)

data(campus)
stargazer(lm(police ~ lcrime + enroll, data = campus), digits = 5, type="text")

data(ceosal1)
stargazer(lm(lsalary ~ lsales + roe , data = ceosal1), digits = 5, type="text")
