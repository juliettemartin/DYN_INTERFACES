echo "complex NB_contacts_F50" > Nb_contacts_N50.txt 

echo "complex NB_residues_F50" > Nb_residues_N50.txt 


# Global plot of contacts for the full MD traj
for complex in 1PVH 1FFW 1PVH 3SGB 1BRS 1EMV  1GCQ  2J0T 2OOB  1AK4 1AY7
do
# split the relevant informations in different files 
grep contact_frequency General_frequency_$complex.txt > contact_frequency.temp
grep '[lr]_frequency' General_frequency_$complex.txt > residue_frequency.temp
grep '[lr]_key' General_frequency_$complex.txt > residue_keys.temp

R CMD BATCH plot_Global_iterface.R 
mv Rplots.pdf Global_interface_$complex.pdf

N=`awk 'BEGIN{N=0;FS="," }{if($1=="contact_frequency"){N=N+1}}END{print N}' General_frequency_$complex.txt`

echo "$complex $N" >> Nb_contacts_N50.txt 


N=`awk 'BEGIN{N=0;FS="," }{if($1=="contact_frequency"){print $2"A";print $3"B"}}' General_frequency_$complex.txt | sort -u | wc -l `
echo "$complex $N" >> Nb_residues_N50.txt 

done
