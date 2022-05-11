
if [ ! -e Nb_clusters.txt ]
then
echo "######"
echo "file Nb_clusters was NOT FOUND, please define it and rerun"

else

# Compute frequency in each cluster, and plot 
echo "######"
echo "running contact_frequency_clusters.sh"
source contact_frequency_clusters.sh

echo "######"
echo "running plot_frequency_clusters.sh"
source plot_frequency_clusters.sh

# TO DO 
# Compare contact variability in rim/core regions
# echo "######"
# echo "running Compare_contact_var_with_rim_core.sh"
# source Compare_contact_var_with_rim_core.sh

# TO DO 
# show on the same plot the Contact frequency variance and the rim/core/information
#echo "######"
#echo "running plot_cluster_interfaces_and_core_labels.sh"
#source plot_cluster_interfaces_and_core_labels.sh

fi
