conda activate ccmap 
# plot with clusters 
CLUSTER_FILES_PATH=../CLUSTERING/

while read line
do
complex=`echo $line| awk '{print $1}' `
nb=`echo $line| awk '{print $2}' `

    if [ ! -e Cluster_centroid_$complex\_$nb.txt ]
    then
   python Compute_contacts_frequency_in_clusters_and_extract_centroids.py --interface_file  Interfaces_$complex.pkl --cluster_file $CLUSTER_FILES_PATH/clusters_$complex.txt --nb $nb > Cluster_centroid_$complex\_$nb.txt 
    fi

done < Nb_clusters.txt


MD_PATH=/Users/jmartin/DYN_INTERFACES/ARWEN_FILES/


while read line
do
complex=`echo $line| awk '{print $1}' `
nb=`echo $line| awk '{print $2}' `

    # all the snapshots 
    split -a 3  -p GENERATED $MD_PATH/$complex/snap.pdb sep_snap_
    T=0
    for file in `ls sep_snap_*`
    do
    awk 'BEGIN{FS="";OFS="";prev_res_num=0;chain="A"}{res_num=substr($0,23,4);if($0~/^ATOM/ && res_num<prev_res_num){chain="B"} if ($0~/^ATOM/){$22=chain};print $0;prev_res_num=res_num}'  $file > sep_snap_temp 
    awk 'BEGIN{FS=""}{if($22=="A"){print $0}}' sep_snap_temp  > rec$T.pdb
    awk 'BEGIN{FS=""}{if($22=="B"){print $0}}' sep_snap_temp  > lig$T.pdb
    T=`expr $T + 1 `
    done

    # read which snapshot to extract
    echo $complex
    while read line2
    do
    cluster=`echo $line2 | awk -F"," '{print $1}'`
    centroid=`echo $line2 | awk -F"," '{print $3}'`
    echo $cluster $centroid
    T=$centroid
    cat rec$T.pdb lig$T.pdb > Centroid_$complex$nb\_$cluster\_$T.pdb
    done < Cluster_centroid_$complex\_$nb.txt 

    rm -f rec*.pdb lig*.pdb  sep_snap_*

done < Nb_clusters.txt

