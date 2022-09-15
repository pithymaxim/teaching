clear

set seed 125

bcuse loanapp, clear
gen test= runiform() < .50

global features1 emp dep appinc married loanamt unit liq lines mortg 
global features2 emp dep appinc married loanamt unit pubrec multi self liq lines mortg atotinc hexp price yjob typur other term fixadj  liq 
global features3 emp dep appinc married loanamt unit pubrec multi self liq lines mortg atotinc hexp price yjob typur other term fixadj  liq 

forvalues i=1/2 {
	lasso logit approve ${features`i'} if test==0
	predict phat`i'
}
 
***************** Python 
* Make ID variable so that python results can be merged back in 
gen id = _n
preserve // save for later 

* Keep only the variable you want to pass to python 
keep approve test id ${features3}

* Save data which will be opened within python
save tmp_for_python.dta, replace 

* Start python
python 
# Load packages (note that we use # to comment in python!)
import pandas as pd
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import RandomizedSearchCV

# Load data 
df = pd.read_stata("tmp_for_python.dta")
# Drop any rows with missing values 
df = df.dropna()
# Make a list of variables to include as features 
#  (i.e., everything but the ID, outcome, and train/test indicator)
Xvars = [x for x in df.columns if x not in ['id','approve','test']]

random_grid = {'n_estimators': [10,50,80,120,150,200], # Original 
			   'max_features': ['auto', 'sqrt'],
			   'max_depth':  [10, 15, 20, 30, 40, 50, 70, None],
			   'min_samples_split': [2, 5, 10],
			   'min_samples_leaf': [1, 2, 4],
			   'bootstrap': [True, False]}

# Declare and estimate the random forest classifier 
rfc = RandomForestClassifier()
clf = RandomizedSearchCV(rfc, random_grid,cv=3,verbose=1,n_iter=10)
clf.fit(df.loc[df.test==0,Xvars].values,df.loc[df.test==0,'approve'].values)

# Show the importance of the features 
ml_importance = pd.DataFrame({'var': Xvars, 'importance': clf.best_estimator_.feature_importances_})
print("Importance of the features, starting from the most important:")
print(ml_importance.sort_values(by='importance',ascending=0))

# Collect predictions 
predictions = clf.predict_proba(df[Xvars].values)[:,1]

# Save a table ("dataframe" in python) containing predictions and the ID variable 
out_df = pd.DataFrame({"id": df.id, "phat3_python": predictions})
out_df.to_stata("tmp_python_predictions.dta")
end
***************** End python work 
* Merge back in with Stata and evaluate your predictions!
restore 
merge 1:1 id using tmp_python_predictions.dta

roccomp approve phat1 phat2 phat3_python if test==1,  /// 
       graph  plot1opts(msize(tiny) lw(vthin)) /// 
	          plot2opts(msize(tiny) lw(vthin)) /// 
	          plot3opts(msize(tiny) lw(vthin)) ///
			  graphregion(color(white)) ///
			  xtitle(False positive rate) ytitle(True positive rate)
			  
erase tmp_for_python.dta
erase tmp_python_predictions.dta
