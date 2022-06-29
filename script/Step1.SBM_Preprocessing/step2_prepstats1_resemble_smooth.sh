subjdir=/media/sf_D_DRIVE/tmp/2021training/sMRI/SBM/subjects
outdir=/media/sf_D_DRIVE/tmp/2021training/sMRI/SBM/stats
fsgd_path=/media/sf_D_DRIVE/tmp/2021training/sMRI/SBM//subjects.fsgd
fwhm=10
data_pref=training

#########main code
datadir=${outdir}/data
mkdir -p ${datadir}
export SUBJECTS_DIR=$subjdir
for t in thickness area volume
do
for h in lh rh 
do
echo $t
mris_preproc --fsgd $fsgd_path --target fsaverage --hemi ${h} --meas ${t} --out ${datadir}/${data_pref}.${h}.${t}.mgh
mri_surf2surf --hemi ${h} --s fsaverage --sval ${datadir}/${data_pref}.${h}.${t}.mgh --fwhm $fwhm --cortex --tval ${datadir}/smooth${fwhm}.${data_pref}.${h}.${t}.mgh
done
done
