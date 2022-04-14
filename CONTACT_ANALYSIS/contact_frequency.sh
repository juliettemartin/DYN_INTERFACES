conda activate ccmap 

for complex in 1PVH 1FFW 1PVH 3SGB 1BRS 1EMV  1GCQ  2J0T 2OOB  1AK4 1AY7
do
    if [ ! -e General_frequency_$complex.txt ]
    then
    python Compute_contacts_frequency.py --interface_file  Interfaces_$complex.pkl	 > General_frequency_$complex.txt
    fi


   if [ ! -e Contact_type_$complex\_2groups.txt ]
    then
    python Contact_type_frequency.py --interface_file  Interfaces_$complex.pkl --category_file category_2groups.txt	 > Contact_type_$complex\_2groups.txt
    fi

   if [ ! -e Contact_type_$complex\_3groups.txt ]
    then
    python Contact_type_frequency.py --interface_file  Interfaces_$complex.pkl --category_file category_3groups.txt	 > Contact_type_$complex\_3groups.txt
    fi


done
