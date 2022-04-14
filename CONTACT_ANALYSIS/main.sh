# Calcul des contacts 

# Store contacts in pkl objects
source compute_contacts.sh

# Calcul la fréquence des contacts le long de la trajectoire and plot it 
source contact_frequency.sh
source plot_frequency.sh

# Calcul frequency in each cluster, and plot 
source contact_frequency_clusters.sh
source plot_frequency_clusters.sh


# Compare contact variability in rim/core regions
source Compare_contact_var_with_rim_core.sh


# show on the same plot the Contact frequency variance and the rim/core/information
source plot_cluster_interfaces_and_core_labels.sh

source contact_frequency.sh
source plot_Contact_type.sh       

