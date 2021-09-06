for complex in 1PVH 3SGB 1FFW 1BRS 1EMV  1GCQ  2J0T 2OOB  1AK4 1AY7
do
echo Jacquard_index_$complex.txt > input.txt
echo $complex >> input.txt
R CMD BATCH plot_dist_matrix.R
mv Rplots.pdf Sim_matrix_$complex.pdf
mv hclust.pdf hclust_$complex.pdf
mv Membership.pdf Membership_$complex.pdf
mv Stability.pdf Stability_$complex.pdf

mv clusters_wide.txt clusters_$complex.txt
mv centroids.txt centroids_$complex.txt 
mv centroids_start150.txt centroids_start_150_$complex.txt 

done


#R CMD BATCH plot_all_dist_matrix.R
#mv Rplots.pdf Matrix_all.pdf


