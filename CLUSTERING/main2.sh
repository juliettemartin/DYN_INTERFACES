if [ -e Nb_clusters.txt ]
then

echo "######"
echo "running Show_centroids_projectionV2.sh"
source Show_centroids_projectionV2.sh

else 
echo "file Nb_clusters.txt was not found"
echo "You need to create it to go further"

fi

