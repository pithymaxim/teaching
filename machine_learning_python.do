bcuse loanapp, clear

keep approve dep emp loanamt married
gen train = runiform()<0.5
gen id = _n
save tmp_for_python.dta, replace 

python 
import pandas as pd
from sklearn.ensemble import RandomForestClassifier

df = pd.read_stata("tmp_for_python.dta")
df = df.dropna()
Xvars = [x for x in df.columns if x not in ['id','approve','train']]

rfc = RandomForestClassifier()
rfc.fit(df.loc[df.train==1,Xvars].values,df.loc[df.train==1,'approve'].values)
predictions = rfc.predict(df[Xvars].values)

out_df = pd.DataFrame({"id": df.id, "ml_preds": predictions})
out_df.to_stata("tmp_python_predictions.dta")
end

use tmp_for_python.dta, clear
merge 1:1 id using tmp_python_predictions.dta