workdir=/media/sf_D_DRIVE/tmp/2021training/sMRI/SBM/stats
datadir=/media/sf_D_DRIVE/tmp/2021training/sMRI/SBM/stats/data
outdir=/media/sf_D_DRIVE/tmp/2021training/sMRI/SBM/stats/atlas
data_pref=smooth10.training
metric_list="thickness area volume"
atlas="aparc"

mkdir -p ${outdir}
for metric in $metric_list
do
for h in rh lh
do
for n in $atlas
do
if [ ${metric} = thickness ]
then
echo ${metric}
mri_segstats --annot fsaverage $h $atlas --exclude 0 --i ${datadir}/${data_pref}.${h}.${metric}.mgh --avgwf ${outdir}/${metric}.${h}.${n}.dat --sum ${outdir}/${metric}.${h}.${n}.summary
else
echo ${metric} 
mri_segstats --annot fsaverage $h $atlas --exclude 0 --i ${datadir}/${data_pref}.${h}.${metric}.mgh --sumwf ${outdir}/${metric}.${h}.${n}.dat --sum ${outdir}/${metric}.${h}.${n}.summary
fi
done
done
done

