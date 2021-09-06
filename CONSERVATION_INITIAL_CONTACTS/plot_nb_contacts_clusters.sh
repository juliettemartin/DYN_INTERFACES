while read line
do
echo $line
complex=`echo $line| awk '{print $1}' `
nb=`echo $line| awk '{print $2}' `

awk -v n=$nb '{print $1" "$n}' ../CLUSTERING/clusters_$complex.txt > clusters.temp

echo Contact_wrt_initial_$complex.txt > input.txt
echo clusters.temp >> input.txt

R CMD BATCH plot_nb_contacts_clusters.R

mv Rplots.pdf plot_nb_$complex.pdf

mv mean.txt mean_$complex.txt
mv sd.txt sd_$complex.txt


done< Nb_clusters.txt

for complex in 2OOB 1GCQ
do
echo Contact_wrt_initial_$complex.txt > input.txt
R CMD BATCH plot_nb_contacts_clusters.R
mv Rplots.pdf plot_nb_$complex.pdf
mv mean.txt mean_$complex.txt
mv sd.txt sd_$complex.txt

done



#R CMD BATCH plot_all_fraction_contacts.R
#mv Rplots.pdf Fraction_initial_all.pdf



