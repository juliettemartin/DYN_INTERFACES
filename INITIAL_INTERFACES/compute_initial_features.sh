conda activate ccmap 
MD_PATH=/Users/jmartin/DYN_INTERFACES/ARWEN_FILES/
SRC_DIR=/Users/jmartin/DYN_INTERFACES/SRC/

for complex in 1FFW 1PVH 3SGB 1BRS 1EMV  1GCQ  2J0T 2OOB  1AK4 1AY7
do
    rm -f protein_rename.pdb
    awk 'BEGIN{FS="";OFS="";prev_res_num=0;chain="A"}{res_num=substr($0,23,4);if($0~/^ATOM/ && res_num<prev_res_num){chain="B"} if ($0~/^ATOM/){$22=chain};print $0;prev_res_num=res_num}' $MD_PATH/$complex/protein_start.pdb > protein_rename.pdb
    RES=`python $SRC_DIR/Compute_delta_ASA.py --struct protein_rename.pdb `
    echo $complex $RES
done > Delta_ASA_initial.txt

for complex in 1FFW 1PVH 3SGB 1BRS 1EMV  1GCQ  2J0T 2OOB  1AK4 1AY7
do
    rm -f protein_rename.pdb
    awk 'BEGIN{FS="";OFS="";prev_res_num=0;chain="A"}{res_num=substr($0,23,4);if($0~/^ATOM/ && res_num<prev_res_num){chain="B"} if ($0~/^ATOM/){$22=chain};print $0;prev_res_num=res_num}' $MD_PATH/$complex/protein_start.pdb > protein_rename.pdb
    python $SRC_DIR/detect_interface.py  --struct protein_rename.pdb  --method Levy 
    mv result.txt description_interface_$complex.txt
done 

