df = read.csv("https://github.com/pithymaxim/teaching/raw/main/data/bam_subsample.csv")

summary(lm(diff_occs ~ weeks_claimed + college + 
               college*weeks_claimed, data=df))

summary(lm(diff_occs ~ long_unemp + college + 
             college*long_unemp, data=df))


# Need to make this a factor variable otherwise ggplot makes an ugly legend
df$college = as.factor(df$college)

df = subset(df, weeks_claimed<=26)

ggplot(data = df, aes(x = weeks_claimed, y = diff_occs, color = college)) +
  stat_summary_bin(fun='mean', bins=20, size=2, geom='point', aes(group=college)) + 
  stat_smooth(data=subset(df, college==1), method = "lm", se= FALSE) +
  stat_smooth(data=subset(df, college==0), method = "lm", se= FALSE)

ggplot(data = df, aes(x = long_unemp, y = diff_occs, color = college)) +
  stat_summary_bin(fun='mean', size=2, geom='point', aes(group=college)) + 
  stat_smooth(data=subset(df, college==1), method = "lm", se= FALSE) +
  stat_smooth(data=subset(df, college==0), method = "lm", se= FALSE)


