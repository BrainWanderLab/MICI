# if you have only one model, you can calculate MICI by your own model. 
# If you want to calculate MICI through multi-models, you can upload your model to our platform http://micc.tmu.edu.cn/mise/index.html

import pandas as pd
import numpy as np
import joblib
import numpy as np
import shap

## Inputs
#feature file#
feature_file='/tmp/data/SBM_feature.csv'
#model name#
model_file='/tmp/models/model_name'# do not add the '.model' extension

##---main code---
#read features
X = pd.read_csv(feature_file, header=None, sep=',')

#calculate MICI#
MICI = []
out_value=[]
model = joblib.load(f'{model_file}.model')
explainer= shap.TreeExplainer(model)
shap_values = explainer.shap_values(X)
for K in range(shap_values.shape[0]):
    base_value=explainer.expected_value 
    out_value=np.sum(shap_values[K,:])+base_value
    MICI.append(out_value)

print()