CONTACT_PATH=../CONTACT_ANALYSIS/
CLUSTER_PATH=../CLUSTERING/


while read line
do
complex=`echo $line| awk '{print $1}' `
nb=`echo $line| awk '{print $2}' `

echo "running computation for complex $complex with $nb clusters"

    if [ ! -e Cluster_frequency_$complex\_$nb.txt ]
    then
    echo "running python script Compute_contacts_frequency_in_clusters.py"
    python Compute_contacts_frequency_in_clusters.py --interface_file  $CONTACT_PATH/Interfaces_$complex.pkl	--cluster_file $CLUSTER_PATH/clusters_$complex.txt --nb $nb > Cluster_frequency_$complex\_$nb.txt
    else 
    echo " File Cluster_frequency_$complex\_$nb.txt  already exists, no computation done"
    fi

done < Nb_clusters.txt
