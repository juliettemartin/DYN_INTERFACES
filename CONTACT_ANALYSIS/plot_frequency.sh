# Global plot of contacts for the full MD traj
while read complex
do
# split the relevant informations in different files 
grep contact_frequency General_frequency_$complex.txt > contact_frequency.temp
grep '[lr]_frequency' General_frequency_$complex.txt > residue_frequency.temp
grep '[lr]_key' General_frequency_$complex.txt > residue_keys.temp

R CMD BATCH plot_global_interface.R 

    if [ -e Rplots.pdf ]
    then
    mv Rplots.pdf Global_interface_$complex.pdf
    echo "File produced Global_interface_$complex.pdf"
    else
    echo "Failed to produced Global_interface_$complex.pdf, see plot_global_interface.Rout"
    fi

N=`awk 'BEGIN{N=0;FS="," }{if($1=="contact_frequency"){N=N+1}}END{print N}' General_frequency_$complex.txt`

rm -f contact_frequency.temp  residue_frequency.temp residue_keys.temp

done < list.txt

