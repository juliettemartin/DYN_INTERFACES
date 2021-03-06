while read complex
do

echo "treating complex $complex"
if [ ! -e Jaccard_index_$complex.txt ]
then
echo "file Jaccard_index_$complex.txt not found, interrupting"
else if [ ]


echo Jaccard_index_$complex.txt > input.txt
echo $complex >> input.txt

echo "running R script run_hclust.R"
R CMD BATCH run_hclust.R

if [ -e centroids.txt ]
then
echo "computation done"
mv Rplots.pdf Sim_matrix_$complex.pdf
mv hclust.pdf hclust_$complex.pdf
mv Membership.pdf Membership_$complex.pdf
mv Stability.pdf Stability_$complex.pdf
mv Stability_var.pdf Stability_var_$complex.pdf

mv clusters_wide.txt clusters_$complex.txt
mv centroids.txt centroids_$complex.txt 
else 
echo "pb in the computation, see the R output run_hclust.Rout "
fi


fi

done <list.txt

