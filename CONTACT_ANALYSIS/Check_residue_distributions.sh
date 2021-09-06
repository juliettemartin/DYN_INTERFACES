# Comparaison des distributions en fonction des catégorie  (contacts variables ou  autre)


for complex in 1AK4 1PVH 1AY7 1BRS 3SGB 1EMV
do 
awk -v complex=$complex '{print complex" "$0}' Max_left_$complex*.txt Max_right_$complex*.txt | grep -v index 
done > Max_var_data.txt


