augsynth_plots = function(augsynth_result, prereg = TRUE, include_notes = TRUE, outcome) { 
  suffix = ""
  # ======== Extract dataframe from augsynth 
  augsynth_df = summary(augsynth_result)$att
  jackknife_SE = summary(augsynth_result, inf_type = "jackknife")$average_att$Std.Error
  avg_att = summary(augsynth_result, inf_type = "jackknife+")$average_att
  est_ub = avg_att$upper_bound - avg_att$Estimate
  est_lb = avg_att$lower_bound - avg_att$Estimate
  
  if (prereg) {
    # Exclude 2023 if part of prereg
    augsynth_df = subset(augsynth_df, year(Time)<2023)
  }
  
  # Load the right df 
  if (grepl("wage",outcome)) {
    df = readRDS("inter/temp_only_build_state_sa.rds")
  }
  if (grepl("emp",outcome)) {
    df = readRDS("inter/temp_only_build_state_monthly_sa.rds")
  }
  
  if (include_notes) {
    nj_mean = mean(as.matrix(df[df$state==34,outcome]))
    nj_mean_formatted = format(round(nj_mean,3), big.mark = ",", scientific = FALSE)
    nj_mean2022 = mean(as.matrix(df[df$state==34 & df$year==2022,outcome]))
    nj_mean2022_formatted = format(round(nj_mean2022,3), big.mark = ",", scientific = FALSE)
    
    my_caption =  paste0("NJ Mean overall: ", nj_mean_formatted, " NJ mean in 2022: ", nj_mean2022_formatted, 
                         "\nCode: ", code_line, 
                         "\nL2 imbalance: ", format(round(augsynth_result$l2_imbalance,3), big.mark = ",", scientific = FALSE), 
                         "\nJackknife+ 95% CI (Lower, Upper): ", "(", round(est_lb,3), ", ", round(est_ub,3), ")", 
                         "\nJackknife SE: ", round(jackknife_SE,3))
  }
  else {
    my_caption = ""
  }
  
  # ======== Make ggplot of real vs. counterfactual 
  pred_df = data.frame(value = c(as.vector(unlist(df[df$state==34,outcome])),
                                 predict(augsynth_result, att=FALSE)), 
                       date = rep(augsynth_result$data$time,2),
                       type= c(rep("New Jersey",length(augsynth_result$data$time)),rep("Counterfactual",length(augsynth_result$data$time))))
  pred_df = pred_df[year(pred_df$date)<2023,]
  
  cf_plot = ggplot(pred_df, aes(x = date, y = value, color = type, linetype = type)) +
    geom_line(size=.7,alpha=0.6) +
    labs(x = "Date", y = name_mapping[outcome], caption = my_caption) +
    scale_color_manual(values = c("New Jersey" = "blue", "Counterfactual" = "red")) +
    scale_linetype_manual(values = c("New Jersey" = "solid", "Counterfactual" = "dashed")) +
    theme_minimal() +
    scale_y_continuous(labels = scales::comma) +
    scale_x_date(date_breaks = "2 years", date_minor_breaks = "1 year", date_labels = "%Y") + 
    theme(legend.position = "right",
          legend.text = element_text(size = 17),
          axis.text.x = element_text(size = 17),
          axis.text.y = element_text(size = 17),
          axis.title.y = element_text(size = 17),
          legend.title = element_blank()) 
  ggsave(file.path(out_folder, paste0("NJ_counterfactual_",outcome,suffix,".pdf")), 
         cf_plot, width = 12, height = 8, dpi = 300)
  return(cf_plot)
}
