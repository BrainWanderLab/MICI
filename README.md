# MICI(Morphometric Integrated Classification Index)
![mici1](https://user-images.githubusercontent.com/107779317/176885585-a967a5c1-d56f-4db9-becc-27e97f568294.png)  

 
## 1.Theory

Morphometric Integrated Classification Index (MICI) is a neuroimaging bimarker developed based on multi-site classification models using structural magnetic resonance imaging (sMRI) data $^1$. It is calculated using the SHapley Additive exPlanation (SHAP) method, which is based on the cooperative game theory $^2$ that measures the average marginal contribution of a feature value to the prediction across the total set of feature vector $^3$. In mathematics, SHAP applies a linear additive model to split the final prediction of a classification model into individual additive contributions (SHAP values) for each valid feature. For a classification model, the relation between prediction probability and SHAP values can be expressed as the following equation:  
[1]  $$logit(P_m)=S_0 + \sum_{f=1}^F {S_f}{X_f}$$              

Where $P_m$ is the prediction probability for a single model m; F is the feature number; $X_f ∈ (0,1)$ is an identifier of feature f, with "0" representing no contribution to the model, and "1" representing a valid contribution of this feature; $S_0$ is the intercept of the linear model (constant value); $S_f$ is the SHAP value of feature f.  

The most important property for SHAP value is the "local accuracy", meaning that the sum of the SHAP values of all valid features is approximately equal to the model prediction $^3$. We extended the SHAP value onto a multisite scenario by ensembling the predictions of multiple "single-site classifiers" into a scalar named MICI value by the following steps:

* (1) The SHAP value of each feature of each participant of each single-site classification model was estimated based on equation [1], resulting in an M (number of models) × P (number of participants) × F (number of features) SHAP matrix; second, the SHAP values of each feature of each participant across sites (or models) were integrated into a feature-wise MICI value weighted by the sample size of each pre-trained model (equation [2]):  
[2]  $$MICI_F= \sum_{m=1}^M(S_{pfm}X_{fm}w_{m}+b_{m}w_{m})$$      
Where p, f, and m represents subjects p, feature f, and model m; M represents the number of models; S represents the SHAP value; $X ∈(0,1)$ is a validity identifier of feature; b is the feature level contribution for intercept: $$b_m=S0_m\sum_{f=1}^F{X_fm }$$ and $w_m$ represents the sample size weight for model m: $$w_m=n_m⁄\sum_{m=1}^M{n_m }$$ 

* (2) The participant-wise MICI values were calculated by aggregating the feature-wise MICI values of all valid features (equation [3]):  
[3] $$MICI_P= \sum_{m=1}^F{MICI_pm}$$            

Because the sum of the SHAP values plus constant S0 is equal to the logit function of the prediction probability in a single model (equation [3]), the relation between participant-wise MICI and the model's predicted probability also follows a logit function as shown in equation [4].  
[4] $$P_{MICI}=\frac{1}\{(1+e^{(-MICI_p)}}$$                   

  
## 2.Usage
### 2.1 Environment Requirements
> - python 3.5
>> - scikit-learn >= 0.20.1
>> - xgboost >= 0.71
>> - shap >=0.32.1
> - FreeSurfer >= 5.3

### 2.2. Procedures
#### Step 1: Surface Based Morphometry (SBM)
- Qualified 3D high-res T1w sMRI images should be included. and FreeSurfer was used to reconstruct cortical surface, parcel areas Destrieux atlas, and segment subcortical structures based on Gaussian Classification Atlas. If you have everything installed, you can run the following scripts:
   ```bash
   cd ./script/Step1.SBM Preprocessing
   ./step1_recon-all_batch.sh
   ```
#### Step 2: Features Extraction
- This step extract the 484 morphometric features for model training or individual prediciton. If you have done SBM, you can run the following scripts:
   ```bash
   cd ./script/Step2.Feature_Extraction
   ./SBM_feature_extract.sh
   ```  
#### Step 3: Model Training 
- This step training a new single-site model based on Xgboost, which can be imbedded into the pior multiple models from other sites to calculate the MICI. If you have done the Step 2 (featuer extraction), and have a many subjects with both patients and healthy controls, you can train your own model using the following scripts:
   ```bash
   cd ./script/Step3.Model_Training
   python Train_model.py
   ```
#### Step 4: MICI calculation
- Based on the extracted feature (step 2) of a new subject, and the trained models based on step 3, you can also calculate the MICI value for this subject to make a prediction (patients: MICI > 0, controls: MICI < 0):
   ```bash
   cd ./script/Step4.MICI_Calculation
   python MICI_One_Model.py
   ```

## **Online Platform**
Besides the offline package mentioned above, we also developed an online free-share platform and wish more and more sites share their models to validate and improve the biomarker’s performance (http://micc.tmu.edu.cn/mici/index.html). In addition, this cloud platform also provides free individual prediction services for the public, which not only provide the predictions based on uploading data, but also the MICI can be obtained directly to perform further scientific research and clinical assistance. This platform has two functions:
### _Indivdual Diagnosis_:
Users can upload the preprocessed features. Then it outputs the diagnostic probability for each subject, the MICI of each subject, and the MICI of each feature of each subject. The correlations between the MICI and clinical symptoms were also available.
### _Model Ensembling_:
Users can train the model off-line and upload their trained model, the performance of the uploaded model based on the public data samples will be used to evaluate the QC of the uploaded model, and the ensembled performance after added the uploaded model into the whole model set will be shown.


![mici_web](https://user-images.githubusercontent.com/107779317/176883220-be284e53-0c24-4aa7-a0d7-492425467651.JPG)


## Copyright
Copyright (c) BrainWanderLab@Tianjin Medical University 2018-2022. All rights reserved.
Please note some component score of MICI contains specific licence or usage constraints for non-academic usage. MICI does not grant the non-academic usage of those scores, so please contact the original score/method providers for proper usage purpose.

## Citation
- [1] Yingying Xie, Hao Ding, Xiaotong Du, Chao Chai, Xiaotong Wei, Jie Sun, Chuanjun Zhuo, Lina Wang, Jie Li, Hongjun Tian, Meng Liang, Shijie Zhang, Chunshui Yu, Wen Qin. Morphometric Integrated Classification Index: A Multisite Model-based, Interpretable, Shareable and Evolvable biomarker for Schizophrenia. Schizophrenia Bulletin, 2022.
- [2] Chalkiadakis G, Elkind E, Wooldridge M. Computational aspects of cooperative game theory. Vol 5: Morgan & Claypool; 2011
- [3]Lundberg SM, Lee S-I. A Unified Approach to Interpreting Model Predictions. 31st Conference on Neural Information Processing Systems (NIPS 2017). Long Beach, CA, USA.; 2017:1-10
 
## Updates
<blockquote>
   - MICI v1.0.0 is released at 2022.7.1
</blockquote>


