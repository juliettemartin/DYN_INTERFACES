

while read line
do
complex=`echo $line| awk '{print $1}' `
nb=`echo $line| awk '{print $2}' `



echo "mm #0 #*" > command.cmd 
echo "color khaki #0:.A" >> command.cmd
echo "color yellow #0:.B" >> command.cmd
echo "color lightgreen #1:.A" >> command.cmd
echo "color green #1:.B" >> command.cmd
echo "color lightblue #2:.A" >> command.cmd
echo "color dodgerblue #2:.B" >> command.cmd
echo "color plum #3:.A" >> command.cmd
echo "color mediumpurple #3:.B" >> command.cmd
chimera  Centroid_1AK44_* command.cmd

done < Nb_clusters.txt

