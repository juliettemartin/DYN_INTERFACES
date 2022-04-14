# Calcul des contacts avec la librairie python de Guillaume 

# conda create -n ccmap python=3.8
# conda activate ccmap 
# pip install ccmap
# pip install pyproteinsExt

conda activate ccmap 
MD_PATH=/Users/jmartin/DYN_INTERFACES/ARWEN_FILES/


for complex in 1PVH 1FFW 1PVH 3SGB 1BRS 1EMV  1GCQ  2J0T 2OOB  1AK4 1AY7
do
    if [ ! -e Interfaces_$complex.pkl ]
    then

    split -a 3  -p GENERATED $MD_PATH/$complex/snap.pdb sep_snap_
    T=0
    for file in `ls sep_snap_*`
    do
    awk 'BEGIN{FS="";OFS="";prev_res_num=0;chain="A"}{res_num=substr($0,23,4);if($0~/^ATOM/ && res_num<prev_res_num){chain="B"} if ($0~/^ATOM/){$22=chain};print $0;prev_res_num=res_num}'  $file > sep_snap_temp 
    awk 'BEGIN{FS=""}{if($22=="A"){print $0}}' sep_snap_temp  > rec$T.pdb
    awk 'BEGIN{FS=""}{if($22=="B"){print $0}}' sep_snap_temp  > lig$T.pdb
    echo $T rec$T.pdb lig$T.pdb
    T=`expr $T + 1 `
    done > list_structures.temp

    python Compute_all_contacts.py 

    mv Interfaces.pkl Interfaces_$complex.pkl	
    rm -f rec*.pdb lig*.pdb  sep_snap_*
    fi

done
