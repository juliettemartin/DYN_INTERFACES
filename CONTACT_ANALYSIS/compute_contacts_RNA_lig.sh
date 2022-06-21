MD_PATH=~/DYN_INTERFACES/2022_06_21_TEST_RNA_LIGAND_TRAJ/DATA/

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
    awk 'BEGIN{FS="";OFS="";chain="A"}{res=$18$19$20; if($0~/^ATOM/ && ! (res=="  A" || res=="  C" || res=="  G" || res=="  U") ){chain="B"} if ($0~/^ATOM/){$22=chain};print $0}'  $file > sep_snap_temp 
    
    # split and remove hydrogen atoms
    awk 'BEGIN{FS=""}{if($22=="A" && $13$14$15!~/H/){print $0}}' sep_snap_temp  > rec$T.pdb
    awk 'BEGIN{FS=""}{if($22=="B" && $13$14$15!~/H/){print $0}}' sep_snap_temp  > lig$T.pdb
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
