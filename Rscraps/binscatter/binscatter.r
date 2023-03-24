binned_scatterplot <- function(data, x_var, y_var, num_bins=20, text_size=20, x_axis_label="",y_axis_label="",quadratic = FALSE) {
  
  # Create bins with roughly equal number of observations in each bin
  x_bin <- cut(data[[x_var]], breaks = unique(quantile(data[[x_var]], probs = seq(0, 1, 1/num_bins))), include.lowest = TRUE)
  
  # Calculate the average value of x and y for each bin
  df <- aggregate(cbind(data[[x_var]],data[[y_var]]) ~ x_bin, data, mean)
  colnames(df)
  names(df)[2] <- "x_mean"
  names(df)[3] <- "y_mean"
  
  # Fit model
  if (quadratic == TRUE) {
    # Quadratic 
    model <- lm(data[[y_var]] ~ data[[x_var]] + I(data[[x_var]]^2), data = data)
  }
  else {
    # Linear 
    model <- lm(data[[y_var]] ~ data[[x_var]],                      data = data)
    # Make a 0 coefficient as a stand-in for the quadratic coefficient. 
    model$coefficients["placeholder"] <- 0
  }
  print(summary(model))
  
  # Make fitted values 
  df$fitted = coef(model)[1] +  coef(model)[2]*df$x_mean + coef(model)[3]*(df$x_mean)^2
  
  if (missing(y_axis_label)) {
    y_axis_label = paste0(y_var, " (Binned)")
  }
  if (missing(x_axis_label)) {
    y_axis_label = paste0(x_var, " (Binned)")
  }
  
  # Make plot 
  ggplot(data=df, aes(y =y_mean, x =x_mean)) +  # geom_abline(intercept = coef(model)[1], slope = coef(model)[2],) +
    geom_line(data = df, aes(y =fitted, x =x_mean),  color = "red", linewidth = 2) +
    geom_point(size = 4, alpha = 0.5, color = "blue") +
    labs(x = x_axis_label, y = y_axis_label) +
    theme(axis.text.x = element_text(size = text_size),
          axis.text.y = element_text(size = text_size),
          axis.title.x = element_text(size = text_size),
          axis.title.y = element_text(size = text_size),
          panel.background = element_blank(),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          axis.line = element_line(color = "black"),
          legend.position = "none") 
}
