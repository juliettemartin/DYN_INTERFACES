# plot with contact frequencies in each clusters 
while read line
do
echo "running computation for complex $complex with $nb clusters"

complex=`echo $line| awk '{print $1}' `
nb=`echo $line| awk '{print $2}' `

    if [ ! -e Cluster_frequency_$complex\_$nb.txt ]
    then
    echo "Pb: file Cluster_frequency_$complex\_$nb.txt not found, no computation done"

    else
    grep contact_frequency Cluster_frequency_$complex\_$nb.txt  > contact_frequency.temp
    grep '[lr]_frequency' Cluster_frequency_$complex\_$nb.txt  > residue_frequency.temp
    grep '[lr]_key' Cluster_frequency_$complex\_$nb.txt  > residue_keys.temp

    R CMD BATCH plot_cluster_interface.R

    if [ -e Rplots.pdf ]
        then
        mv Rplots.pdf Interface_$complex\_$nb\_clusters.pdf
        echo "File generated Interface_$complex\_$nb\_clusters.pdf"
        # create chimera session with residues colored according to the variability of contacts 
        echo "attribute: contact_var
        match mode: 1-to-1
        recipient: residues" > res_attributes_$complex\_$nb.txt
        awk '{print "\t:"$2".A\t"$3}' max_var_left_residues.txt >> res_attributes_$complex\_$nb.txt
        awk '{print "\t:"$2".B\t"$3}' max_var_right_residues.txt >> res_attributes_$complex\_$nb.txt
        #awk 'BEGIN{FS="";OFS="";prev_res_num=0;chain="A"}{res_num=substr($0,23,4);if($0~/^ATOM/ && res_num<prev_res_num){chain="B"} if ($0~/^ATOM/){$22=chain};print $0;prev_res_num=res_num}'  $STRUCT_DIR/$complex/protein_start.pdb > protein.pdb
        echo color yellow \#:.A > command.cmd
        echo color tan \#:.B >> command.cmd
        echo defattr res_attributes.txt >> command.cmd
        echo rangecol contact_var min blue max red >> command.cmd
        echo save session_$complex\_$nb.py >> command.cmd

        mv command.cmd command_$complex\_$nb.cmd
        echo 'created a chimera script to visualize residues colored by contact variability'
        echo ' you can visualize your protein using:'
        echo chimera my_protein.pdb command_$complex\_$nb.cmd
        #chimera --nogui protein.pdb  command_$complex\_$nb.cmd 

        else
        echo 'Pb: failed to generate plot Rplots.pdf '
        fi
    fi

    echo "remove temp files"
    rm -f contact_frequency.temp residue_frequency.temp residue_keys.temp

done < Nb_clusters.txt




