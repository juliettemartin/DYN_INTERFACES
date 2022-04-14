
INTERFACE_DIR=../INITIAL_INTERFACES/


while read line
do
complex=`echo $line| awk '{print $1}' `
nb=`echo $line| awk '{print $2}' `
grep contact_frequency Cluster_frequency_$complex\_$nb.txt  > contact_frequency.temp
grep '[lr]_frequency' Cluster_frequency_$complex\_$nb.txt  > residue_frequency.temp
grep '[lr]_key' Cluster_frequency_$complex\_$nb.txt  > residue_keys.temp
cp $INTERFACE_DIR/description_interface_$complex.txt ./interface.temp
R CMD BATCH plot_cluster_interfaces_and_core_labels.R
cp Contact_variance.pdf Contact_variance_$complex\_$nb.pdf
cp Contact_variance_big.pdf Contact_variance_big_$complex\_$nb.pdf
cp Contact_frequencies_big.pdf Contact_frequencies_big_$complex\_$nb.pdf
done < Nb_clusters.txt



