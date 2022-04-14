# centroid selection according to the Jaccard similarity matrix in CLUSTERING
CLUSTER_FILES_PATH=~/DYN_INTERFACES/2021_06_04_INTERFACE_CONTACTS/CLUSTERING/

while read line
do
complex=`echo $line| awk '{print $1}' `
nb=`echo $line| awk '{print $2}' `
awk -v N=$nb '{if($1==N){print $0}}' $CLUSTER_FILES_PATH/centroids_$complex.txt  | cut -d" " -f2- > index.temp

for i in 6 #1 2 3  
do

echo "color hot pink #*:.A" > color_residues_$complex.cmd
echo "color tan #*:.B" >> color_residues_$complex.cmd
python3 color_residues_v$i.py --pkl ../Interfaces_$complex.pkl --index index.temp >> color_residues_$complex.cmd
echo "select :.A" >> color_residues_$complex.cmd
echo "hbonds retainCurrent true reveal true   saveFile Hbonds.txt selRestrict :.B  intermodel false namingStyle simple linewidth 5" >> color_residues_$complex.cmd
#echo "findclash #:.A  test  #:.B  overlapCutoff -0.4 hbondAllowance 0  makePseudobonds true lineWidth 3  pbColor orange  namingStyle simple" >> color_residues_$complex.cmd
#echo "~ribbon #:.B"  >> color_residues_$complex.cmd
echo "surface #" >> color_residues_$complex.cmd
echo "transparency 60,s #" >> color_residues_$complex.cmd
mv color_residues_$complex.cmd color_$complex\_v$i.cmd
done


#echo "color hot pink #*:.A" > color_residues_$complex.cmd
#echo "color tan #*:.B" >> color_residues_$complex.cmd
#python3 color_residues_v2.py --pkl ../Interfaces_$complex.pkl --index index.temp --N 2 >> color_residues_$complex.cmd
#echo "select :.A" >> color_residues_$complex.cmd
#echo "hbonds retainCurrent true reveal true   saveFile Hbonds.txt selRestrict :.B  intermodel false namingStyle simple linewidth 3" >> color_residues_$complex.cmd
#echo "findclash #:.A  test  #:.B  overlapCutoff -0.4 hbondAllowance 0  makePseudobonds true lineWidth 3  pbColor orange  namingStyle simple" >> color_residues_$complex.cmd
#echo "~ribbon #:.B" 
#mv color_residues_$complex.cmd color_$complex\_v2_N2.cmd

#chimera Centroid_1BRS2_* color_residues_1BRS.cmd 


done < Nb_clusters.txt

