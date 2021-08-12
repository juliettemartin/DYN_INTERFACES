conda activate ccmap 
# plot with clusters 
CLUSTER_FILES_PATH=../CLUSTERING/

while read line
do
complex=`echo $line| awk '{print $1}' `
nb=`echo $line| awk '{print $2}' `

    if [ ! -e Cluster_frequency_$complex\_$nb.txt ]
    then
    python Compute_contacts_frequency_in_clusters.py --interface_file  Interfaces_$complex.pkl	--cluster_file $CLUSTER_FILES_PATH/clusters_$complex.txt --nb $nb > Cluster_frequency_$complex\_$nb.txt
    fi

done < Nb_clusters.txt
