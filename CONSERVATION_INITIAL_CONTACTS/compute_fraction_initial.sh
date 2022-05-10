MD_PATH=/Users/jmartin/DYN_INTERFACES/ARWEN_FILES/

while read complex 
do
    if [ ! -e Contact_wrt_initial_$complex.txt ]
    then

    echo "treating $complex"
    echo "running python script Compute_common_contacts_from_pkl.py"

    echo Time NB_initial NB_contacts NB_common Fraction_common > Contact_wrt_initial_$complex.txt 
    python Compute_common_contacts_from_pkl.py --interface_file ../CONTACT_ANALYSIS/Interfaces_$complex.pkl >> Contact_wrt_initial_$complex.txt  



    if [ `wc -l  Contact_wrt_initial_$complex.txt  | awk '{print $1}'` -eq 1 ] 
    then
    rm -f Contact_wrt_initial_$complex.txt 
    fi

    if [ ! -e Contact_wrt_initial_$complex.txt   ]
    then    
        echo "Warning: failed to produce Contact_wrt_initial_$complex.txt  "
    fi


    else
    echo "Contact_wrt_initial_$complex.txt already exists, no computation done"

    fi

done <list.txt
