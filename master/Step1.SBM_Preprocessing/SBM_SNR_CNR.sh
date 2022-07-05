#!/bin/sh

if [ $# -lt 1 ]
  then
  echo "Usage: $0 <subjects_dir> [<subjlist>] [-force] "
  exit 1
fi

export SUBJECTS_DIR=$1;

if  [ $# -lt 2 ]
  then
  subs=`ls $1`;
else
  subs=`cat $2`
fi

rerun=$3
 
echo $rerun
if [ -f $SUBJECTS_DIR/snr_reports ]
  then mv $SUBJECTS_DIR/snr_reports $SUBJECTS_DIR/snr_reports_bak`date +%Y-%m-%d-%H-%M-%S`
fi

if [ -f $SUBJECTS_DIR/cnr_reports ]
  then mv $SUBJECTS_DIR/cnr_reports $SUBJECTS_DIR/cnr_reports_bak`date +%Y-%m-%d-%H-%M-%S`
fi

echo -e "subjectID\tsnr\tmean\tstd\tNvoxel\tNerode" > $SUBJECTS_DIR/snr_reports
echo -e "subjectID\tlh.GM-WM\tlh.GM-CSF\trh.GM-WMt\trh.GM-CSF\tlh\trh\ttotal" >  $SUBJECTS_DIR/cnr_reports
echo -e "=======\nsnr/cnr reports paths:  $SUBJECTS_DIR/snr(cnr)_reports"
for s in $subs
  do 
  if [ -d $SUBJECTS_DIR/$s ]
    then
    if [[ ! -f $SUBJECTS_DIR/$s/stats/wmsnr.e3.dat ]] || [[ "$rerun" == "-force" ]]
      then
      wm-anat-snr --s $s --force > /tmp/wm_snr.log 2>&1
    fi
    if [[ ! -f $SUBJECTS_DIR/$s/stats/cnr.dat ]] || [[ "$rerun" == "-force" ]]
      then
      mri_cnr $SUBJECTS_DIR/$s/surf  $SUBJECTS_DIR/$s/mri/norm.mgz > $SUBJECTS_DIR/$s/stats/tmpcnr.dat 2>&1
      echo -e "#subjectID\tlh.GM-WM\tlh.GM-CSF\trh.GM-WMt\trh.GM-CSF\tlh\trh\ttotal" >  $SUBJECTS_DIR/$s/stats/cnr.dat
      lhGW=`grep "gray/white CNR" $SUBJECTS_DIR/$s/stats/tmpcnr.dat |sed -n 1p|awk -F "," '{print $1}'|awk '{print $4}'`
      lhGC=`grep "gray/white CNR" $SUBJECTS_DIR/$s/stats/tmpcnr.dat |sed -n 1p|awk -F "," '{print $2}'|awk '{print $4}'`
      lh=`grep "lh CNR" $SUBJECTS_DIR/$s/stats/tmpcnr.dat|awk '{print $4}'`
      rhGW=`grep "gray/white CNR" $SUBJECTS_DIR/$s/stats/tmpcnr.dat |sed -n 2p|awk -F "," '{print $1}'|awk '{print $4}'`
      rhGC=`grep "gray/white CNR" $SUBJECTS_DIR/$s/stats/tmpcnr.dat |sed -n 2p|awk -F "," '{print $2}'|awk '{print $4}'`
      rh=`grep "rh CNR" $SUBJECTS_DIR/$s/stats/tmpcnr.dat|awk '{print $4}'`
      tot=`grep "total CNR" $SUBJECTS_DIR/$s/stats/tmpcnr.dat|awk '{print $4}'`
      echo -e "${s}\t${lhGW}\t${lhGC}\t${rhGW}\t${rhGC}\t${lh}\t${rh}\t${tot}" >> $SUBJECTS_DIR/$s/stats/cnr.dat
      rm -f $SUBJECTS_DIR/$s/stats/tmpcnr.dat
    fi
    sed -n 1p  $SUBJECTS_DIR/$s/stats/wmsnr.e3.dat >> $SUBJECTS_DIR/snr_reports
    sed -n 2p $SUBJECTS_DIR/$s/stats/cnr.dat >> $SUBJECTS_DIR/cnr_reports
    sed -n 2p $SUBJECTS_DIR/$s/stats/cnr.dat
  fi
done

