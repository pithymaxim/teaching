import numpy as np
import pandas as pd
import statsmodels.api as sm
import seaborn as sns
import matplotlib.pyplot as plt

df = pd.read_stata("https://github.com/pithymaxim/teaching/raw/refs/heads/main/data/auto.dta")

X = sm.add_constant(df['mpg'])
y = df['price']
model = sm.OLS(y,X).fit()

df['yhat'] = model.predict()
df['residuals'] = model.resid

df.plot(x='mpg', y=['price', 'yhat'], style='o')
