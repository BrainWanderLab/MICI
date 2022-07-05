script_dir=/media/sf_D_DRIVE/tmp/2021training/sMRI/script/SBM
T1dir=/media/sf_D_DRIVE/tmp/2021training/sMRI/DTI_pipe/T1
subject_list=/media/sf_D_DRIVE/tmp/2021training/sMRI/dicom/subjlist
T1_name=T1.nii
workdir=/media/sf_D_DRIVE/tmp/2021training/sMRI/SBM
nthread=3



##########################################################################
# main code (do not edit)
pipe()
{    
    echo "======Start SBM pipeline for Subject: $s($k/$njob)======"
    echo "======Start SBM pipeline for Subject: $s($k/$njob)======" > $logdir/${s}.log 
    tstart=`date +%s`
    cmd="$script_dir/recon-all_s1.sh ${T1dir}/${s}/${T1_name} $s $SUBJECTS_DIR $fs_home"
    echo $k/$njob: $cmd
    echo $cmd >> $logdir/${s}.log
    $cmd >> $logdir/${s}.log
    tend=`date +%s`
    tspend=`echo $tend - $tstart |bc`
    echo "------Finish SBM pipeline for Subject:$s($tspend seconds) ------"
    echo "------Finish SBM pipeline for Subject:$s($tspend seconds) ------">> $logdir/${s}.log 

}
logdir=$workdir/logs
SUBJECTS_DIR=$workdir/subjects
fs_home=$FREESURFER_HOME
if [ ! -d $logdir ];then mkdir -p $logdir;fi
if [ ! -d $SUBJECTS_DIR ];then mkdir -p $SUBJECTS_DIR;fi
njob=`cat $subject_list|wc -l`
k=1
for s in `cat $subject_list`
    do
    if [ $k -lt $njob ]
        then
        pipe &
        if [ $((k%nthread)) -eq 0 ]
            then
            wait
        fi
    else
       pipe
    fi
    k=$((k+1))
done
