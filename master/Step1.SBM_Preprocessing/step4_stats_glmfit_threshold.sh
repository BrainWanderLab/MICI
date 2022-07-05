data_path=/media/sf_D_DRIVE/tmp/2021training/sMRI/SBM/stats/data/smooth10.training.lh.thickness.mgh
fsgd_path=/media/sf_D_DRIVE/tmp/2021training/sMRI/SBM/stats/ttest/ttest.fsgd
glmdir=/media/sf_D_DRIVE/tmp/2021training/sMRI/SBM/stats/ttest/lh_thickness
mask=/media/sf_D_DRIVE/tmp/2021training/sMRI/SBM/subjects/fsaverage/label/lh.cortex
contrast_dir=/media/sf_D_DRIVE/tmp/2021training/sMRI/SBM/stats/ttest
contrast_name=LB_SC
hemi=lh

MultiCompCorr=cluster  # fdr cluster uncorr
bonf=2
logp_thr=2
clustsize=10
## parameter for cluster-wise correction
nsim=100
clust_basename=MonteCarlo
fwhm=10
## parameter for vertex-wise fdr correction
fdr_thr=0.05
######## Main Code##################
mkdir  -p $glmdir
mri_glmfit --y ${data_path} --fsgd ${fsgd_path} doss --C ${contrast_dir}/${contrast_name} --surf fsaverage ${hemi} --glmdir $glmdir
if [ "$MultiCompCorr" == "cluster" ];then
echo ${glmdir}/${clust_basename}-VoxP${logp_thr}-${contrast_name}.csd
if [ ! -f "${glmdir}/${clust_basename}-VoxP${logp_thr}-${contrast_name}.csd" ];then
mri_glmfit --y ${data_path} --fsgd ${fsgd_path} doss --C ${contrast_dir}/${contrast_name} --surf fsaverage ${hemi} --glmdir $glmdir --sim mc-z $nsim $logp_thr ${glmdir}/${clust_basename}-VoxP${logp_thr} --fwhm $fwhm
fi
fi
if [ "$MultiCompCorr" == "uncorr" ];then
mri_surfcluster --in ${glmdir}/${contrast_name}/sig.mgh --thmin $logp_thr --subject fsaverage --hemi ${hemi} --surf white --annot aparc.a2009s --clabel ${mask}  --minarea ${clustsize} --sum ${glmdir}/${contrast_name}/${hemi}.uncorrP${logp_thr}.c${clustsize}.summary --o ${glmdir}/${contrast_name}/${hemi}.uncorrP${logp_thr}.c${clustsize}.logP.mgh --olab ${glmdir}/${contrast_name}/${hemi}.uncorrP${logp_thr}.c${clustsize}
elif [ "$MultiCompCorr" == "fdr" ];then
mri_surfcluster --in ${glmdir}/${contrast_name}/sig.mgh --fdr ${fdr_thr} --bonferroni $bonf --subject fsaverage --hemi ${hemi} --surf white --annot aparc.a2009s --clabel ${mask}  --minarea ${clustsize} --sum ${glmdir}/${contrast_name}/${hemi}.fdr${fdr_thr}.c${clustsize}.summary --o ${glmdir}/${contrast_name}/${hemi}.fdr${fdr_thr}.c${clustsize}.logP.mgh --olab ${glmdir}/${contrast_name}/${hemi}.fdr${fdr_thr}.c${clustsize}
else
mri_surfcluster --in ${glmdir}/${contrast_name}/sig.mgh --thmin $logp_thr --subject fsaverage --hemi ${hemi} --surf white --annot aparc.a2009s --clabel ${mask}  --csd ${glmdir}/${clust_basename}-VoxP${logp_thr}-${contrast_name}.csd  --sum ${glmdir}/${contrast_name}/${hemi}.uncorrP${logp_thr}.cluster_corrected.summary --o ${glmdir}/${contrast_name}/${hemi}.uncorrP${logp_thr}.cluster_corrected.logP.mgh --olab ${glmdir}/${contrast_name}/${hemi}.uncorrP${logp_thr}.cluster_corrected
fi
