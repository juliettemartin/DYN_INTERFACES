# DYN_INTERFACES
Scripts to analyze the contacts at PPI during MD simulations.

# extract contacts from MD snapshots
cd CONTACT_ANALYSIS
source main.sh

# Assess conservation of contacts over time 
cd CONSERVATION_INITIAL_CONTACTS
source main.sh

# Perform Clustering based on interface contacts
cd CLUSTERING
source main.sh

# Analyse contacts in each cluster 

NB : for this, you need to decide the number of clusters and write it in a file with the following format:

PDB_ID NB_CLUSTER

And then 

cd CONTACT_ANALYSIS

source main.sh

cd CENTROID_V2

source main.sh


# Compute Interface properties
cd DELTA_ASA

source main.sh 

cd GAP_INDEX

source main.sh
