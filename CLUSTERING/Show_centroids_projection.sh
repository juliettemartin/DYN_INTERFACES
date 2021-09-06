# plot with contact frequencies in each clusters 
while read line
do
complex=`echo $line| awk '{print $1}' `
nb=`echo $line| awk '{print $2}' `

awk 'BEGIN{FS=","}{printf $3" "}'  ../CONTACT_ANALYSIS/CENTROID_V1/Cluster_centroid_$complex\_$nb.txt  > centroids-v1.temp 

grep ^$nb centroids_$complex.txt | cut -d" " -f2- > centroids-v2.temp

echo Jacquard_index_$complex.txt > input.txt
echo $complex >> input.txt
echo centroids-v1.temp >> input.txt 
echo centroids-v2.temp >> input.txt 



R CMD BATCH show_centroids_projection.R
mv Rplots.pdf Projection_$complex\_$nb.pdf
mv ProjectionV2.pdf ProjectionV2_$complex\_$nb.pdf

done < Nb_clusters.txt

