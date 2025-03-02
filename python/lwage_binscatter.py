import wooldridge
df = wooldridge.data('wagepan')

sns.pointplot(df,
            x='year',
            y='lwage',
            ci=None,
            hue='married')
