# if you have only one model, you can calculate MICI by your own model. 
# If you want to calculate MICI through multi-models, you can upload your model to our platform http://micc.tmu.edu.cn/mise/index.html

import pandas as pd
import numpy as np
import joblib
import numpy as np
import shap

#read feature file#
X = pd.read_csv('./SBM_feature.csv', header=None, sep=',')

#model name#
model_list=['model_name']####if you have only one model, you can calculate MICI by your model

#calculate MICI#
MICI = []
out_value=[]
for ith_mothod in model_list:
    model_name=ith_mothod
    model = joblib.load(f'{model_name}.model')
    explainer= shap.TreeExplainer(model)
    shap_values = explainer.shap_values(X)
    for K in range(shap_values.shape[0]):
        base_value=explainer.expected_value 
        out_value=np.sum(shap_values[K,:])+base_value
        MICI.append(out_value)

print()