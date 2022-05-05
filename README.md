# DYN_INTERFACES
Scripts to analyze the contacts at PPI during MD simulations.

The scripts rely on the ccmap and pypstruct packages, so you will need to install them in a local envt: 

conda create -n dyn_interfaces python=3.8

conda activate dyn_interfaces

pip install ccmap

pip install pypstruct


Perform the following steps in the indicated order.

# extract contacts from MD snapshots
cd CONTACT_ANALYSIS

source main.sh

cd ..

# Assess conservation of contacts over time 
cd CONSERVATION_INITIAL_CONTACTS

source main.sh

cd ..
# Perform Clustering based on interface contacts
cd CLUSTERING

source main.sh

cd ..
# Analyse contacts in each cluster 

NB : for this, you need to decide the number of clusters and write it in a file with the following format:

PDB_ID NB_CLUSTER

And then 

cd CONTACT_ANALYSIS

source main.sh

cd ..

cd CENTROID_V2

source main.sh

cd ..


# Compute Interface properties
cd DELTA_ASA

source main.sh 

cd GAP_INDEX

source main.sh
