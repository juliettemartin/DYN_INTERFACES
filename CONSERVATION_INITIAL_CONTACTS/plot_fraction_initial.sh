while read complex 
do
    if [ -e Contact_wrt_initial_$complex.txt ] 
    then
    echo "making individual plot for $complex"
    echo Contact_wrt_initial_$complex.txt > input.txt
    echo $complex >> input.txt
    R CMD BATCH plot_fraction_contacts.R
        if [ -e Rplots.pdf ]
        then
        mv Rplots.pdf Fraction_initial_$complex.pdf
        echo "File generated successfully: Fraction_initial_$complex.pdf"
        else
        echo "Pb: failed to generate Fraction_initial_$complex.pdf"
        fi
    else 
    echo "Contact_wrt_initial_$complex.txt was not found, done nothing"
    fi
done <list.txt
