# Homework 1
# March 20, 2023 
# Jane Doe 
  
#########################################################
# Question 1: Math                             ##########
#########################################################

1+2

# I find that the answer is 3. 

########################################################
# Question 2: Load data and run regression    ##########
########################################################

data(mtcars)
summary(lm(mpg~disp, data=mtcars))

# The coefficient is -0.04.
