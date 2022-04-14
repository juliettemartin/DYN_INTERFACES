# plot with contact frequencies in each clusters 
while read line
do
complex=`echo $line| awk '{print $1}' `
nb=`echo $line| awk '{print $2}' `

grep ^$nb centroids_$complex.txt | cut -d" " -f2- > centroids-v2.temp

echo Jacquard_index_$complex.txt > input.txt
echo $complex >> input.txt
echo centroids-v2.temp >> input.txt 

R CMD BATCH show_centroids_projectionV2.R
mv ProjectionV2.pdf ProjectionV2_$complex\_$nb.pdf

mv Time_line.pdf Time_line.pdf_$complex\_$nb.pdf

mv Time_line_no_centroid.pdf Time_line_no_centroid_$complex\_$nb.pdf

done < Nb_clusters.txt

