# activate envt
source activate dyn_interfaces 

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
