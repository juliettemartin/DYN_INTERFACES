MD_PATH=/Users/jmartin/DYN_INTERFACES/ARWEN_FILES/

while read complex 
do
    if [ ! -e Jacquard_index_$complex.txt    ]
    then

    echo "treating complex $complex"

       echo "splitting trajectory into separate files"

    case "$(uname -s)" in
    Darwin)
    split -a 3  -p GENERATED $MD_PATH/$complex/snap.pdb sep_snap_
    ;;

    Linux)
    echo 'Linux'
    csplit -k $MD_PATH/$complex/snap.pdb  '/GENERATED/' '{*}' -f sep_snap_ -n 3 -z 
    ;;

    *)
    echo 'Other OS' 
    ;;
    esac

    echo "..."

    echo "reformatting separate files with chain Ids"
    T=0
    for file in `ls sep_snap_*`
    do
    awk 'BEGIN{FS="";OFS="";prev_res_num=0;chain="A"}{res_num=substr($0,23,4);if($0~/^ATOM/ && res_num<prev_res_num){chain="B"} if ($0~/^ATOM/){$22=chain};print $0;prev_res_num=res_num}'  $file > sep_snap_temp 
    awk 'BEGIN{FS=""}{if($22=="A"){print $0}}' sep_snap_temp  > rec$T.pdb
    awk 'BEGIN{FS=""}{if($22=="B"){print $0}}' sep_snap_temp  > lig$T.pdb
    echo $T rec$T.pdb lig$T.pdb
    T=`expr $T + 1 `
    done > list_structures.temp
    echo " -> created a temporary list: "
    wc -l list_structures.temp
    echo "..."

    echo "running python file Compute_Jacquard.py "

    echo Time1 Time2 NB_contacts1 NB_contacts2 NB_common  > Jacquard_index_$complex.txt 
    python Compute_Jacquard.py >> Jacquard_index_$complex.txt   

    if [ `wc -l  Jacquard_index_$complex.txt | awk '{print $1}'` -eq 1 ] 
    then
    rm -f Jacquard_index_$complex.txt
    fi

    if [ ! -e Jacquard_index_$complex.txt  ]
    then    
        echo "Warning: failed to produce Jacquard_index_$complex.txt "
    fi

    echo "remove temporary files"
    rm -f rec*.pdb lig*.pdb  sep_snap_*

    else
    echo "file Jacquard_index_$complex.txt  already exists, no computation run"
    fi

done <list.txt
