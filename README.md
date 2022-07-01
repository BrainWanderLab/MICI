## MICI
   - The derived MICI biomarker has comparable predicition performance as the ensembling model, is strongly associated with brain damage, clinical symptoms, and expressions profile (interpretable). Our platform collectively highlights a highly shareable and interpretable framework to support clinicians in the neuroimage classification diagnosis of schizophrenia. Besides, we developed an online model share platform to promote the generalization of MICI and provide free individual prediction services (http://micc.tmu.edu.cn/mici/index.html). 
       
   - Please note some component score of MICI contains specific license or usage constraints for non-academic usage. MICI does not grant the non-academic usage of those scores, so please contact the original score/method providers for proper usage purpose.  
 
   - We welcome any discussion, suggestion and potential contribution of new functional prediction scores through github or contact Dr. Wen Qin (wayne.wenqin@gmail.com).
   
   - Citation. Morphometric Integrated Classification Index: A Multisite Model-based, Interpretable, Shareable and Evolvable biomarker for Schizophrenia

**Updates**
<blockquote>
   - MICI v1.0.0 is released. 
</blockquote>


## Usage
### Requirements
- python 3.5
- scikit-learn >= 0.20.1
- xgboost >= 0.71
- shap >=0.32.1
- FreeSurfer >= 5.3

## 1. Data preparation and feature extraction

The first step for data preparation is MRI preprocessing. Qualified MRI images can be included, and FreeSurfer was used to extract structural brain features, which is based on Destrieux atlas, GC atlas and whole-brain features (can be found in our paper).

## 2. Model training and MICI calculation
Based on the feature matrix, the classification model was trained with XGBoost, and MICI was calculated based on shap values.

### Procedures
If you have everything installed, you can use the script to preprocess MRI data with FreeSurfer:
   ```bash
   cd ./script/Step1.SBM Preprocessing
   ./step1_recon-all_batch.sh
   ```
If you have data preprocessed, you can use the script to extract fatures:
   ```bash
   cd ./script/Step2.Feature_Extraction
   ./SBM_feature_extract.sh
   ```  
If you have feature extracted, you can use the script to train the model:
   ```bash
   cd ./script/Step3.Model_Training
   python Train_model.py
   ```
If you have trained your models, you can use the script to calculate MICI based on your model.
   ```bash
   cd ./script/Step4.MICI_Calculation
   python MICI_One_Model.py
   ```

**Notes**
<blockquote>
If you want to calculate MICI using multi-models, you can upload your model and extracted features to our platform (http://micc.tmu.edu.cn/mici/index.html).
</blockquote>


## Copyright
Copyright (c) BrainWanderLab@Tianjin Medical University 2018-2022. All rights reserved.
Please note some component score of MICI contains specific licence or usage constraints for non-academic usage. MICI does not grant the non-academic usage of those scores, so please contact the original score/method providers for proper usage purpose.


## Citation
Morphometric Integrated Classification Index: A Multisite Model-based, Interpretable, Shareable and Evolvable biomarker for Schizophrenia
