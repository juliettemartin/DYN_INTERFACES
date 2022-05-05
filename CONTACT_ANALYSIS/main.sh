# Calcul des contacts 

if [ ! -e Nb_clusters.txt ]
then
echo "######"
echo "file Nb_clusters was NOT FOUND, run preliminary analyses will be run"

# Store contacts in pkl objects
echo "######"
echo "running compute_contacts.sh"
source compute_contacts.sh

# Compute contact frequency
echo "######"
echo "running contact_frequency.sh"
source contact_frequency.sh

# Plot contact frequency
echo "######"
echo "running plot_frequency.sh"
source plot_frequency.sh


else

echo "file Nb_clusters was found, *post-clustering* analyses will be run "

# Compute frequency in each cluster, and plot 
echo "######"
echo "running ccontact_frequency_clusters.sh"
source contact_frequency_clusters.sh

echo "######"
echo "running plot_frequency_clusters.sh"
source plot_frequency_clusters.sh


# Compare contact variability in rim/core regions
echo "######"
echo "running Compare_contact_var_with_rim_core.sh"
source Compare_contact_var_with_rim_core.sh


# show on the same plot the Contact frequency variance and the rim/core/information
echo "######"
echo "running plot_cluster_interfaces_and_core_labels.sh"
source plot_cluster_interfaces_and_core_labels.sh


echo "######"
echo "contact_frequency.sh"
source contact_frequency.sh

echo "######"
echo "plot_Contact_type.sh "
source plot_Contact_type.sh       

fi
