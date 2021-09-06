INTERFACE_DIR=../INITIAL_INTERFACES/

# plot with contact frequencies in each clusters 
while read line
do
complex=`echo $line| awk '{print $1}' `
nb=`echo $line| awk '{print $2}' `

grep contact_frequency Cluster_frequency_$complex\_$nb.txt  > contact_frequency.temp
grep [lr]_frequency Cluster_frequency_$complex\_$nb.txt  > residue_frequency.temp
grep [lr]_key Cluster_frequency_$complex\_$nb.txt  > residue_keys.temp
cp $INTERFACE_DIR/description_interface_$complex.txt ./interface.temp

R CMD BATCH Compare_cluster_var_with_rimcore.R 
mv average_var_by_contact_category.txt average_var_by_contact_category_$complex\_$nb.txt
mv Rplots.pdf Contact_var_by_category_$complex\_$nb.pdf

mv Summed_var_left_residues.txt Var_left_$complex\_$nb.txt
mv Summed_var_right_residues.txt Var_right_$complex\_$nb.txt

mv Max_var_left_residues.txt Max_left_$complex\_$nb.txt
mv Max_var_right_residues.txt Max_right_$complex\_$nb.txt

done < Nb_clusters.txt




