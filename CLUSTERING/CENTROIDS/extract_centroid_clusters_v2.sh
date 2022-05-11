# centroid selection according to the Jaccard similarity matrix in CLUSTERING
CLUSTER_FILES_PATH=../
MD_PATH=/Users/jmartin/DYN_INTERFACES/ARWEN_FILES/

while read line
do
complex=`echo $line| awk '{print $1}' `
nb=`echo $line| awk '{print $2}' `
echo "extraction of centroids for complex $complex and $nb clusters"

    if [ ! -e Cluster_centroid_$complex\_$nb.txt ]
    then

    echo "splitting the snapshots"
    # all the snapshots 
    case "$(uname -s)" in
    Darwin)
    split -a 3  -p GENERATED $MD_PATH/$complex/snap.pdb sep_snap_
    ;;

    Linux)
    echo 'Linux'
    csplit -k $MD_PATH/$complex/snap.pdb  '/GENERATED/' '{*}' -f sep_snap_ -n 3 -z 
    ;;

    *)
    echo 'Other OS' 
    ;;
    esac

    echo "reformatting for chain ids"
    T=0
    for file in `ls sep_snap_*`
    do
    awk 'BEGIN{FS="";OFS="";prev_res_num=0;chain="A"}{res_num=substr($0,23,4);if($0~/^ATOM/ && res_num<prev_res_num){chain="B"} if ($0~/^ATOM/){$22=chain};print $0;prev_res_num=res_num}'  $file > sep_snap_temp 
    awk 'BEGIN{FS=""}{if($22=="A"){print $0}}' sep_snap_temp  > rec$T.pdb
    awk 'BEGIN{FS=""}{if($22=="B"){print $0}}' sep_snap_temp  > lig$T.pdb
    T=`expr $T + 1 `
    done


    TIMES=`awk -v N=$nb '{if($1==N){print $0}}' $CLUSTER_FILES_PATH/centroids_$complex.txt  | cut -d" " -f2- `

    echo "writing centroid PDB"
    cluster=1
    for T in `echo $TIMES`
        do
        cat rec$T.pdb lig$T.pdb > Centroid_$complex$nb\_$cluster\_$T.pdb
        cluster=` expr $cluster + 1 `
        done 

        rm -f rec*.pdb lig*.pdb  sep_snap_*
    fi

done < Nb_clusters.txt  # Nb_clusters.txt
