
while read complex 
do
    if [ ! -e General_frequency_$complex.txt ]
    then
    echo "running python script Compute_contacts_frequency.py"
    python Compute_contacts_frequency.py --interface_file  Interfaces_$complex.pkl	 > General_frequency_$complex.txt
    
        if [ ! -e General_frequency_$complex.txt ]
        then
        echo "failed to create General_frequency_$complex.txt "
        fi

    else
    echo "General_frequency_$complex.txt already exists, no computation done"
    fi


   if [ ! -e Contact_type_$complex\_2groups.txt ]
    then
    echo "running python script Contact_type_frequency.py with 2 AA groups"
    python Contact_type_frequency.py --interface_file  Interfaces_$complex.pkl --category_file category_2groups.txt	 > Contact_type_$complex\_2groups.txt
        if [ ! -e Contact_type_$complex\_2groups.txt ]
        then
        echo "failed to create Contact_type_$complex\_2groups.txt"
        fi
    else
    echo "Contact_type_$complex\_2groups.txt already exists, no computation done"
    fi

   if [ ! -e Contact_type_$complex\_3groups.txt ]
    then
    echo "running python script Contact_type_frequency.py with 3 AA groups"
    python Contact_type_frequency.py --interface_file  Interfaces_$complex.pkl --category_file category_3groups.txt	 > Contact_type_$complex\_3groups.txt
         if [ ! -e Contact_type_$complex\_3groups.txt ]
        then
        echo "failed to create Contact_type_$complex\_3groups.txt"
        fi   
    else
    echo "Contact_type_$complex\_3groups.txt  already exists, no computation done"
    fi
done < list.txt
