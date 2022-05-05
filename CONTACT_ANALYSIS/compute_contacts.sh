conda activate dyn_interfaces
MD_PATH=/Users/jmartin/DYN_INTERFACES/ARWEN_FILES/

while read complex
do

    echo "treating complex $complex"

    if [ ! -e Interfaces_$complex.pkl ]
    then
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

    echo "running python file "
    python Compute_all_contacts.py 

    if [ ! -e Interfaces.pkl ]
    then    
        echo "Warning: failed to produce Interfaces.pkl"
    else
        mv Interfaces.pkl Interfaces_$complex.pkl	
    fi

    echo "remove temporary files"
    rm -f rec*.pdb lig*.pdb  sep_snap_*

    else
    echo "file Interfaces_$complex.pkl  already exists, no computation run"

    fi
done < list.txt 
