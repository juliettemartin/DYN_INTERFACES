if [ ! -e Nb_clusters.txt ]
then
echo "file Nb_clusters.txt does not exist, please cerate it"
echo "format : PDB Nb_clusters"
fi


# plot with contact frequencies in each clusters 
while read line
do
complex=`echo $line| awk '{print $1}' `
nb=`echo $line| awk '{print $2}' `

echo "showing centroids for complex $complex and $nb clusters"

grep ^$nb centroids_$complex.txt | cut -d" " -f2- > centroids-v2.temp

echo Jaccard_index_$complex.txt > input.txt
echo $complex >> input.txt
echo centroids-v2.temp >> input.txt 


echo "runing R script show_centroids_projectionV2.R"

R CMD BATCH show_centroids_projectionV2.R

    if [ -e ProjectionV2.pdf ]
    then
    mv ProjectionV2.pdf ProjectionV2_$complex\_$nb.pdf
    mv Time_line.pdf Time_line_$complex\_$nb.pdf
    mv Time_line_no_centroid.pdf Time_line_no_centroid_$complex\_$nb.pdf
    else
    echo "Pb running the R script, check the R output show_centroids_projectionV2.Rout"
    fi

done < Nb_clusters.txt

