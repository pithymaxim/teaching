import wooldridge
df = wooldridge.data('bwght')
df['female'] = np.where(df['male']==0,1,0)

model = sm.OLS(df['bwght'], sm.add_constant(df[['female','male']])).fit()
print(model.summary())

# Diagnosing the multi-colinearity
df[['male','female','bwght']].corr()
