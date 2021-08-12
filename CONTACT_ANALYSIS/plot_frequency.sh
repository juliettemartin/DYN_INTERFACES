# Global plot of contacts for the full MD traj
for complex in 1FFW 1PVH 3SGB 1BRS 1EMV  1GCQ  2J0T 2OOB  1AK4 1AY7
do
# split the relevant informations in different files 
grep contact_frequency General_frequency_$complex.txt > contact_frequency.temp
grep [lr]_frequency General_frequency_$complex.txt > residue_frequency.temp
grep [lr]_key General_frequency_$complex.txt > residue_keys.temp

R CMD BATCH plot_Global_iterface.R 
mv Rplots.pdf Global_interface_$complex.pdf

done
