
from sklearn.preprocessing import LabelEncoder
from sklearn.preprocessing import Imputer
from sklearn.model_selection import StratifiedKFold
from sklearn.model_selection import GridSearchCV
from xgboost import XGBClassifier
import pandas as pd
import numpy as np
import random
import joblib

# parameters
model_name = 'model_name'
ds_file = f'./PSY_{model_name}.csv'
ds = pd.read_csv(f'{ds_file}', header=None, sep=',')

K = 5 # k-fold of cross validation
EPOCH = 10 # epoch number of gridsearch 

# -----------------------data processing --------------------------------------
imputer = Imputer(missing_values=np.nan)
StKFold = StratifiedKFold(n_splits=K, random_state=9, shuffle=True)

# -----------------------parmeters of Grid-Search --------------------------------------

cv_params_list = [{'n_estimators': range(100,1001,100)},
                {'max_depth': range(1,10) ,'min_child_weight': range(1,8)},
                {'colsample_bytree': [x/10 for x in range(3,11)],'subsample': [x/10 for x in range(5,11)], 'colsample_bylevel': [x/10 for x in range(3,11)]},
                {'gamma': [x/10 for x in range(0,51,2)]},
                {'reg_alpha': [5,2,1,0.1,0.01,0.001,0], 'reg_lambda': [5,2,1,0.1,0.01,0.001,0]},
                {'learning_rate': [0.01,0.02,0.05,0.1,0.15,0.2]}
                ]
set_num = 0
model = [XGBClassifier]
score_metric = ['roc_auc','neg_mean_squared_error']
best_params = {}


X = ds.loc[:,:-1] # feature
y = ds.loc[:,-1]  # label

label_encoder = LabelEncoder()
y = label_encoder.fit_transform(y)

scale_pos_weight = (len(y)-sum(y))/sum(y)

cv_params_list_copy = cv_params_list.copy()
ind_params = {'scale_pos_weight':scale_pos_weight}
old_params = ind_params.copy()

print(f'---- {model_name}: BEGIN TRAINING ----')

# grid search group by group
for e in range(EPOCH):
    for cv_params in cv_params_list_copy:
        GS_XGB = GridSearchCV(model[set_num](**ind_params), cv_params,scoring=score_metric[set_num],cv=StKFold, n_jobs=-1)
        GS_XGB.fit(X,y)
        
        for key,value in GS_XGB.best_params_.items():
            ind_params[key] = value
        print("try to find: {}\n score:{}".format(cv_params.keys(),GS_XGB.best_score_))
    
    # show the best params set
    print("The best params found in epoch {} is:\n{}".format(e, ind_params))
    if (old_params == ind_params) and (e >= 3) :
        best_params[model_name] = ind_params
        break
    old_params = ind_params.copy()
    random.shuffle(cv_params_list_copy)

best_model = XGBClassifier(**best_params[model_name])
best_model.fit(X, y)

joblib.dump(best_model, f'./{model_name}_model.model')

print('---- {train_set_name} TRAINING FINISHED ----')




