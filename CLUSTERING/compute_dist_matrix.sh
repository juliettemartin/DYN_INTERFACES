while read complex 
do
    if [ ! -e Jacquard_index_$complex.txt    ]
    then

    echo "treating complex $complex"

    echo "running python file Compute_Jacquard_from_pkl.py "

    echo Time1 Time2 NB_contacts1 NB_contacts2 NB_common  > Jacquard_index_$complex.txt 
    python Compute_Jacquard_from_pkl.py --interface_file ../CONTACT_ANALYSIS/Interfaces_$complex.pkl >> Jacquard_index_$complex.txt   

    if [ `wc -l  Jacquard_index_$complex.txt | awk '{print $1}'` -eq 1 ] 
    then
    rm -f Jacquard_index_$complex.txt
    fi

    if [ ! -e Jacquard_index_$complex.txt  ]
    then    
        echo "Warning: failed to produce Jacquard_index_$complex.txt "
    else 
        echo "File generated: Jacquard_index_$complex.txt"
    fi

    else
    echo "file Jacquard_index_$complex.txt  already exists, no computation run"
    fi

done <list.txt
