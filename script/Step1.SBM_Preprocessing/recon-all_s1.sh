#!/bin/bash
#$ -cwd
#$ -j y
#$ -S /bin/bash
datapath=$1
subj=$2
subj_dir=$3
fs_home=$4
export FREESURFER_HOME=$4
export SUBJECTS_DIR=$3
source ~/.bashrc
mkdir -p $SUBJECTS_DIR
if [ -f $datapath ];then
mkdir -p $SUBJECTS_DIR/$2/mri/orig
$FREESURFER_HOME/bin/mri_convert ${datapath} ${SUBJECTS_DIR}/$2/mri/orig/001.mgz
echo $FREESURFER_HOME/bin/recon-all  -all -s $2
$FREESURFER_HOME/bin/recon-all  -all -s $2
fi
