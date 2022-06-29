workdir=/media/sf_D_DRIVE/tmp/2021training/sMRI/SBM/stats
datadir=${workdir}/data
outdir=${workdir}/ROI
subjects_dir=/media/sf_D_DRIVE/tmp/2021training/sMRI/SBM/subjects
labeldir=/media/sf_D_DRIVE/tmp/2021training/sMRI/SBM/subjects/fsaverage/label
data_pref=smooth10.training
metric_list="thickness area volume"

export SUBJECTS_DIR=$subjects_dir
mkdir ${outdir}
for metric in $metric_list
do
for h in rh lh
do
for n in cortex
do
if [ ${metric} = thickness ]
then
echo ${metric}
mri_segstats --slabel fsaverage $h ${labeldir}/${h}.${n} --exclude 0 --i ${datadir}/${data_pref}.${h}.${metric}.mgh --avgwf ${outdir}/${metric}.${h}.${n}.dat --sum ${outdir}/${metric}.${h}.${n}.summary
else
echo ${metric} 
mri_segstats --slabel fsaverage $h ${labeldir}/${h}.${n} --exclude 0 --i ${datadir}/${data_pref}.${h}.${metric}.mgh --sumwf ${outdir}/${metric}.${h}.${n}.dat --sum ${outdir}/${metric}.${h}.${n}.summary
fi
done
done
done

