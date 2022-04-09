bcuse loanapp, clear

keep approve dep emp loanamt married

* Make test/train indicator 
gen train = runiform()<0.5

* Make ID variable so that python results can be merged back in 
gen id = _n

* Save data which will be opened within python
save tmp_for_python.dta, replace 

* Start python
python 

# Load packages (note that we use # to comment in python!)
import pandas as pd
from sklearn.ensemble import RandomForestClassifier

# Load data 
df = pd.read_stata("tmp_for_python.dta")
# Drop any rows with missing values 
df = df.dropna()
# Make a list of variables to include as features 
#  (i.e., everything but the ID, outcome, and train/test indicator)
Xvars = [x for x in df.columns if x not in ['id','approve','train']]

# Declare and estimate the random forest classifier 
rfc = RandomForestClassifier()
rfc.fit(df.loc[df.train==1,Xvars].values,df.loc[df.train==1,'approve'].values)

# Collect predictions 
predictions = rfc.predict(df[Xvars].values)

# Save a table ("dataframe" in python) containing predictions and the ID variable 
out_df = pd.DataFrame({"id": df.id, "ml_preds": predictions})
out_df.to_stata("tmp_python_predictions.dta")
end

* Merge back in with Stata and evaluate your predictions!
use tmp_for_python.dta, clear
merge 1:1 id using tmp_python_predictions.dta
