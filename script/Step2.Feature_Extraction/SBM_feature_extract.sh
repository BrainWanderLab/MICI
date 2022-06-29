#!/bin/sh

if [ $# -lt 3 ]
  then
  echo "Usage: $0 <subjects_dir> <labels> <subjlist> <outpath>"
  echo "       <<subjects_dir: SUBJECTS_DIR where SBM running"
  echo "       <<labels: CSV file defining the feature labels (see example)"
  echo "       <<subjlist: text files containing subject IDs"
  echo "       >>outpath: output file path (csv)"
  exit 1
fi


export SUBJECTS_DIR=$1
labels=$2
subs=`cat $3`
outpath=$4
if [ $# -lt 4 ]
  then outpath=$SUBJECTS_DIR/SBM_features.csv
fi

if [ -f $outpath ]
  then mv $outpath ${outpath}_bak`date +%Y-%m-%d-%H-%M-%S`
fi
touch $outpath

echo -e "======= Extract SBM features ======"
echo "--SUBJECTS_DIR: $1"
echo "--label file: $2"
echo "--subject list: $3"
echo "--output: $outpath"
# headline 
nlab=`cat $labels|wc -l`
for n in `seq 2 $nlab`
  do
  areainfo=`sed -n ${n}p $labels`
  region=`echo $areainfo|awk -F "," '{print $1}'`
  metric=`echo $areainfo|awk -F "," '{print $2}'`
  atlas=`echo $areainfo|awk -F "," '{print $3}'` 
  labelname=`echo $areainfo|awk -F "," '{print $4}'` 
  if [ $n -eq 2 ]
    then
    headline="SubjectID,$labelname"
    else
    headline="$headline,$labelname"
  fi
done
echo $headline > $outpath

for s in $subs
  do
  subdir=$SUBJECTS_DIR/$s
  row=$s
  for n in `seq 2 $nlab`
    do
    areainfo=`sed -n ${n}p $labels`
    region=`echo $areainfo|awk -F "," '{print $1}'`
    metric=`echo $areainfo|awk -F "," '{print $2}'`
    atlas=`echo $areainfo|awk -F "," '{print $3}'`
    atlasF=`ls $subdir/stats/*${atlas}*`
    nF=`echo $atlasF|awk '{print NF}'`
    if [ "$metric" == "global" ]
      then
      #single atlas 
      if [ $nF -eq 1 ]
        then 
        val=`cat $atlasF|grep "\<$region\>"|awk -F "," '{print $(NF-1)}'`
      else
        val=0
        for F in `seq 1 $nF`
          do
          tmpF=`echo $atlasF|awk '{print $'$F'}'`
          tmpval=`cat $tmpF|grep "\<$region\>"|awk -F "," '{print $(NF-1)}'`
          val="${val}+$tmpval"
        done
        val=`echo "$val"|bc`
      fi
    else   
       case $metric in
         vol)
         ncol=4
         ;;
         SurfArea)
         ncol=4
         ;;
         GrayVol)
         ncol=5
         ;;
         ThickAvg)
         ncol=6
         ;;
       esac
       val=`cat $atlasF|grep "\<$region\>"|awk '{print $'$ncol'}'`
    fi
    row="${row},$val"
  done
  echo $row >> $outpath 
  echo ....subj: $s
done
