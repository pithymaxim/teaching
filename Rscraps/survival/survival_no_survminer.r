################### How to make a survival plot using only the survival library
load(file = "Army_built.Rdata")

library(survival)

# Another option for using the survfit option. Need ~1 if you want to not split by anything
km_split_mar =   survfit(Surv(years_of_service,separated)~1,data= subset(df,married==1))
km_split_unmar = survfit(Surv(years_of_service,separated)~1,data= subset(df,married==0))

#### rep() function examples 

#### c(1:3) examples 

# Make a dataframe
# Toy example with data.frame()
my_test_df = data.frame(letters = c("a","b","c"),
                        numbers = c(7,8,9))
rep(c(1,0), each=1)
rep(c(1,0), each=2)
rep(c(1,0), each=3)

surv_df2 = data.frame(survival= c(km_split_mar$surv,km_split_unmar$surv),
                      married =rep(c(1,0),each=length(km_split_mar$surv)),
                      time=     c(km_split_mar$time,km_split_unmar$time))

# Now a regular ggplot line can be made using the dataframe
ggplot(surv_df2, aes(y=survival,x=time,color=as.factor(married))) + 
  geom_line() + 
  scale_color_manual(values = c("red", "black"),
                     labels = c("Unmarried", "Married")) + 
  labs(title = "Survival by Time and Marriage Status",
       x = "Time in years",
       y = "Fraction still enlisted",
       color = "Marriage Status")
