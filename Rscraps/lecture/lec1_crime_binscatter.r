### Load packages #########
library(wooldridge)
library(ggplot2)
###########################

# Load crime1
data(crime1)

# Create 20 bins with roughly equal number of observations in each bin
crime1$inc86_bin <- cut(crime1$inc86, breaks=unique(quantile(crime1$inc86, probs = seq(0, 1, 0.05))), include.lowest = TRUE)

# Calculate the average value of x for each bin
df_x <- aggregate(inc86 ~ inc86_bin, crime1, mean)

# Calculate the average value of y for each bin
df_y <- aggregate(narr86 ~ inc86_bin, crime1, mean)

# Merge the two data frames
df <- merge(df_x, df_y, by = "inc86_bin")

# Fit linear regression model
model <- lm(narr86 ~ inc86, data = crime1)

# Set text size
text_size <- 24

# Create binned scatter plot with linear fit
ggplot(df, aes(x = inc86, y = narr86)) +
  geom_abline(intercept = coef(model)[1], slope = coef(model)[2], color = "red", linewidth=2) +
  geom_point(size = 4, alpha = 0.5, color = "blue") +
  theme(axis.text.x = element_text(size = text_size),
        axis.text.y = element_text(size = text_size),
        axis.title.x = element_text(size = text_size),
        axis.title.y = element_text(size = text_size),
        panel.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.line = element_line(color = "black"),
        legend.position = "none") 
