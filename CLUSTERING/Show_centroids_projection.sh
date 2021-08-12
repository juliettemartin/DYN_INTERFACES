# plot with contact frequencies in each clusters 
while read line
do
complex=`echo $line| awk '{print $1}' `
nb=`echo $line| awk '{print $2}' `
grep ^$nb centroids_$complex.txt | cut -d" " -f2- > centroids.temp

echo Jacquard_index_$complex.txt > input.txt
echo $complex >> input.txt
echo centroids.temp >> input.txt 

R CMD BATCH show_centroids_projection.R
mv Rplots.pdf Projection_$complex\_$nb.pdf

done < Nb_clusters.txt