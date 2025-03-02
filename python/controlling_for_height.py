import numpy as np
import pandas as pd
import statsmodels.api as sm
import seaborn as sns
import matplotlib.pyplot as plt

df = pd.read_csv('https://github.com/pithymaxim/teaching/raw/refs/heads/main/data/nba.csv')

def residualizer(y,X):
  return sm.OLS(y,sm.add_constant(X)).fit().resid + y.mean()

df['rebound_residualized'] = residualizer(df['reb'],df['player_height'])
df['weight_residualized'] = residualizer(df['player_weight'],df['player_height'])

fig, axes = plt.subplots(1, 2, figsize=(16, 6))

sns.regplot(data=df,
            x='player_weight',
            y='reb',
            x_bins=30,
            ci = None,
            ax = axes[0])

sns.regplot(data=df,
            x='weight_residualized',
            y='rebound_residualized',
            x_bins=30,
            ci = None,
            ax = axes[1])
axes[1].set_ylim(1,7)
