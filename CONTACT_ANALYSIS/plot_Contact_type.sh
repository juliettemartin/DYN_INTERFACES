while read line
do
echo $line
complex=`echo $line| awk '{print $1}' `
nb=`echo $line| awk '{print $2}' `

awk -v n=$nb '{print $1" "$(n+1)}' ../CLUSTERING/clusters_$complex.txt > clusters.temp

echo Contact_type_$complex\_2groups.txt > input.txt 
echo clusters.temp >> input.txt
R CMD BATCH plot_Contact_type.R
mv Boxplot.pdf Boxplot2groups_$complex\_$nb.pdf

echo Contact_type_$complex\_3groups.txt > input.txt 
echo clusters.temp >> input.txt
R CMD BATCH plot_Contact_type3.R
mv Boxplot.pdf Boxplot3groups_$complex\_$nb.pdf
mv Boxplot_raw.pdf Boxplot_raw3groups_$complex\_$nb.pdf

mv Rplots.pdf Boxplot3groups_legend.pdf




done < Nb_clusters.txt





