nba = read.csv("https://raw.githubusercontent.com/pithymaxim/teaching/main/data/nba.csv")
stargazer(lm(reb ~ player_weight, data=nba), type="text")
