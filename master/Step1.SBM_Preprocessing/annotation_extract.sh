data_path=/media/sf_D_DRIVE/tmp/2021training/sMRI/SBM/stats/data/smooth10.training.lh.thickness.mgh
outdir=/media/sf_D_DRIVE/tmp/2021training/sMRI/SBM/stats/ROI_extract
out_pref=lh_thickness
atlas=aparc
h=lh


mkdir ${outdir}
mri_segstats --annot fsaverage $h $atlas --exclude 0 --i $data_path --avgwf ${outdir}/${out_pref}.${h}.${atlas}.dat --sum ${outdir}/${out_pref}.${h}.${atlas}.summary

