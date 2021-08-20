MD_PATH=/Users/jmartin/DYN_INTERFACES/ARWEN_FILES/
SRC_DIR=/Users/jmartin/DYN_INTERFACES/SRC/

for complex in 1PVH 3SGB 1BRS 1EMV 1GCQ 2OOB 1AK4 1AY7
do
    if [ ! -e Delta_ASA_$complex.txt ]
    then

    echo 'T ASA_A ASA_B ASA_AB Delta_ASA' > Delta_ASA_$complex.txt
    split -a 3  -p GENERATED $MD_PATH/$complex/snap.pdb sep_snap_
    T=0
    for file in `ls sep_snap_*`
    do
    awk 'BEGIN{FS="";OFS="";prev_res_num=0;chain="A"}{res_num=substr($0,23,4);if($0~/^ATOM/ && res_num<prev_res_num){chain="B"} if ($0~/^ATOM/){$22=chain};print $0;prev_res_num=res_num}'  $file > sep_snap_temp.pdb
    python $SRC_DIR/Compute_delta_ASA_v2.py --struct sep_snap_temp.pdb
    RES=`cat result.txt`
    echo $T $RES >> Delta_ASA_$complex.txt
    rm -f result.txt $file 
    T=`expr $T + 1 `
    done 
    fi
done
