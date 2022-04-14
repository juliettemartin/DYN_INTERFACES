source extract_centroid_clusters_v2.sh

# un test pour essayer de colorer les contacts selon leur conservation dans les representatives, mais ça ne marche pas car Chimera ne conserve pas les sets de pseudoBonds
#source  color_differential_contacts_in_centroids.sh

# idem but with residues 
source color_differential_residues_in_centroids.sh

source count_differential_residues_in_centroids.sh

# ensuite, pour faire les images pour un complexe :
# chimera Centroid_1AY73_1_75.pdb Centroid_1AY73_2_240.pdb Centroid_1AY73_3_192.pdb color_1AY7_v6.cmd 
# puis charger et superposer les structures avec l'eau : DYN_INTERFACES/2021_09_15_DATA_ELISA/Water/Representative_structures_waters


