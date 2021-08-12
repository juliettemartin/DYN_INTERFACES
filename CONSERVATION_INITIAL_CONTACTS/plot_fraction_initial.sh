for complex in 1PVH 3SGB 1BRS 1EMV  1GCQ 2OOB  1AK4 1AY7
do
echo Contact_wrt_initial_$complex.txt > input.txt
echo $complex >> input.txt
R CMD BATCH plot_fraction_contacts.R
mv Rplots.pdf Fraction_initial_$complex.pdf
done

R CMD BATCH plot_all_fraction_contacts.R
mv Rplots.pdf Fraction_initial_all.pdf



