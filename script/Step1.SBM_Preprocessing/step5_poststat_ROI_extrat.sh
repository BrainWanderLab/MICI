data_path=/media/sf_D_DRIVE/tmp/2021training/sMRI/SBM/stats/data/smooth10.training.lh.thickness.mgh
outdir=/media/sf_D_DRIVE/tmp/2021training/sMRI/SBM/stats/ROI_extract
out_pref=lh_thickness
roilist=/media/sf_D_DRIVE/tmp/2021training/sMRI/SBM/stats/ROI/labellist
h=lh
mkdir ${outdir}
for r in `cat $roilist`
do echo roi: $r
roiname=${r##*/}
mri_segstats --slabel fsaverage $h $r --exclude 0 --i $data_path --avgwf ${outdir}/${out_pref}.${h}.${roiname}.dat --sum ${outdir}/${out_pref}.${h}.${roiname}.summary
done

