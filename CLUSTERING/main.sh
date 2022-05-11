# activate envt 
source activate dyn_interfaces

echo "######"
echo "running compute_dist_matrix.sh"
source compute_dist_matrix.sh

echo "######"
echo "running hclust.sh"
source run_hclust.sh

