# activate envt 
source activate dyn_interfaces

echo "######"
echo "running compute_dist_matrix.sh"
source compute_dist_matrix.sh

echo "######"
echo "running hclust.sh"
source run_hclust.sh

echo "######"
echo "running Show_centroids_projectionV2.sh"
source Show_centroids_projectionV2.sh
