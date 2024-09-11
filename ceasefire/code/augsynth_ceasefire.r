library(magrittr)
library(dplyr)
library(augsynth)
library(ggplot2)
library(haven)

setwd(file.path(dropbox, "berkeley/projects/ceasefire"))

# Load data
df = read_dta("inter/ceasefire_balanced_quarter.dta")

# Make R date from the Stata date 
df$r_date <- as.Date(df$date, origin = "1960-01-01")

# Run augmented synthetic control 
syn <- augsynth(murders ~ treated, unit=city_num, time=r_date, df,
                       progfunc = "Ridge", scm = T)
result = summary(syn, inf_type = "jackknife+")
print(result)
print(result$average_att)

plot(syn, inf_type = "jackknife+")

# Make augsynth plot showing treated and counterfactual 
pred_df = data.frame(value = c(as.vector(unlist(df[df$ever_treated==1,"murders"])),
                               predict(syn, att=FALSE)), 
                     date = rep(syn$data$time,2),
                     type= c(rep("Boston",length(syn$data$time)),
                             rep("Counterfactual",length(syn$data$time))))

ggplot(pred_df, aes(x = date, y = value, color = type, linetype = type)) +
geom_line(size=.7,alpha=0.6) +
labs(x = "Date", y = "Murders") +
scale_color_manual(values = c("Boston" = "blue", "Counterfactual" = "red")) +
scale_linetype_manual(values = c("Boston" = "solid", "Counterfactual" = "dashed")) +
theme_minimal() +
scale_y_continuous(labels = scales::comma) +
scale_x_date(date_breaks = "2 years", date_minor_breaks = "1 year", date_labels = "%Y") + 
  geom_vline(xintercept = as.Date("1996-05-15"), linetype = "solid", color = "purple", size = 1.5) +
theme(legend.position = "right",
      legend.text = element_text(size = 17),
      axis.text.x = element_text(size = 17),
      axis.text.y = element_text(size = 17),
      axis.title.y = element_text(size = 17),
      legend.title = element_blank()) 


