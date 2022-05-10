# centroid selection according to the Jaccard similarity matrix in CLUSTERING
CLUSTER_FILES_PATH=~/DYN_INTERFACES/2021_06_04_INTERFACE_CONTACTS/CLUSTERING/

while read line
do
complex=`echo $line| awk '{print $1}' `
nb=`echo $line| awk '{print $2}' `
awk -v N=$nb '{if($1==N){print $0}}' $CLUSTER_FILES_PATH/centroids_$complex.txt  | cut -d" " -f2- > index.temp


python3 count_stable_residues.py --pkl ../Interfaces_$complex.pkl --index index.temp >count_residues_$complex.txt


done < Nb_clusters.txt #Nb_clusters_short.txt

