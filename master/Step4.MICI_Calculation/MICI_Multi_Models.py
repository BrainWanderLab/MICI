import pandas as pd
import numpy as np
import joblib
import numpy as np
import shap
## Inputs
#model list#
model_dir='/tmp/models/'
model_list=['model_1','model_2','model_3',...,'model_n'] # do not add the '.model' extension

#feature file#
feature_file='/tmp/data/SBM_feature.csv'

#define number of subjects in each model
numbers = [n1, n2, n3, n4,...,nn]##number of subjects in each model


##---Main---
#read feature file
X = pd.read_csv(feature_file, header=None, sep=',')
#calculate MICI of each model#
MICI = []
out_value=[]
for ith_mothod in model_list:
    model_name=ith_mothod
    model = joblib.load(f'{model_dir} {model_name}.model')
    explainer= shap.TreeExplainer(model)
    shap_values = explainer.shap_values(X)
    for K in range(shap_values.shape[0]):
        base_value=explainer.expected_value 
        out_value=np.sum(shap_values[K,:])+base_value
        MICI.append(out_value)

MICI=np.array( MICI)
num=round(len(MICI)/len(model_list))
MICI = MICI.reshape((len(model_list),num))

#calculate weight of each model#
weight = []
for i in range(len(numbers)):
    N=sum(numbers)
    w=numbers[i]/N
    weight.append(w)

#calculate MICI based on muiti models#
MICI_multi=[]
for i in range(len(numbers)):
    MICI_n=MICI[i,:]*weight[i]
    MICI_multi.append(MICI_n)

MICI_multi=np.array(MICI_multi)
MICI_multi= MICI_multi.reshape((len(model_list),num))
MICI_used=np.sum(MICI_multi,axis=0)

print(MICI_used)

