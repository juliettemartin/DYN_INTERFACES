while read line
do

complex=`echo $line| awk '{print $1}' `
nb=`echo $line| awk '{print $2}' `

awk -v n=$nb '{print $1" "$n}' ../CLUSTERING/clusters_$complex.txt > clusters.temp

echo Gap_Volume_$complex.txt > input.txt
echo ../DELTA_ASA/Delta_ASA_$complex.txt >>input.txt
echo clusters.temp >> input.txt

R CMD BATCH plot_gap_volume.R

mv Rplots.pdf Gap_$complex.pdf
mv Index.pdf Index_$complex.pdf

mv mean.txt mean_$complex.txt
mv sd.txt sd_$complex.txt
done < Nb_clusters.txt

for complex in 2OOB 1GCQ
do
echo Gap_Volume_$complex.txt > input.txt
echo ../DELTA_ASA/Delta_ASA_$complex.txt >>input.txt
R CMD BATCH plot_gap_volume.R

mv Rplots.pdf Gap_$complex.pdf
mv Index.pdf Index_$complex.pdf

mv mean.txt mean_$complex.txt
mv sd.txt sd_$complex.txt
done



