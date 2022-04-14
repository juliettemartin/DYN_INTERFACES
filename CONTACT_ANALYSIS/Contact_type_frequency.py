import pickle
import argparse
import sys

def args_gestion():
        parser = argparse.ArgumentParser(description = "A programm to analyse contacts at interface during MD" )
        parser.add_argument("--interface_file", metavar = "<file>", help = "Mandatory. Name of the pkl file to analyse", required=True)
        parser.add_argument("--category_file", metavar = "<file>", help = "Mandatory. Name of the pkl file to analyse", required=True)
        return parser.parse_args()
# Read arguments 
ARGS = args_gestion()

# need to specify rb and not only r, otherwise I get an error 
# UnicodeDecodeError: 'utf-8' codec can't decode byte 0x80 in position 0: invalid start byte
with open(ARGS.interface_file,'rb') as file:
    Contacts=pickle.load(file)
 

with open(ARGS.category_file,'r') as file:
    lines=file.readlines()

#print(lines)
Category={}
cat_list=[]

for L in lines:
    cat,aa_names=L.split()
    if not cat in cat_list:
        cat_list.append(cat)
    for aa in str(aa_names).split(','):
        Category[aa]=cat
 
# lr = left residue, rr=right residues
lr_list=[]
rr_list=[]
# Compute the frequency of all the contacts in the snapshots
# C=contact
# R=residues
# This are Frequency tables 

R_Frequency_left={}
R_Frequency_right={}
T=0
print("T",end=" ")
for c1 in cat_list:
    for c2 in cat_list:
        if c1<=c2:
            print(c1+"/"+c2,end=" ")
print("")

for snapshot in Contacts:
    print(str(T),end=" ")
    C_Frequency={}
    for c1 in cat_list:
        for c2 in cat_list:
            if c1<=c2:
                C_Frequency[c1+"/"+c2]=0
    for c in Contacts[snapshot]:
        left_residue=(c.split("/")[0].split(":")[0]).split(' ')[0]
        right_residue=(c.split("/")[1].split(":")[0]).split(' ')[0]
 
        try:
            l_cat=Category[left_residue]
            r_cat=Category[right_residue]
            if l_cat<=r_cat:
                p_cat=l_cat+'/'+r_cat
            else:
                p_cat=r_cat+'/'+l_cat
            C_Frequency[p_cat]+=1
        except:
            i=1
    for c1 in cat_list:
        for c2 in cat_list:
            if c1<=c2:
                print(C_Frequency[c1+"/"+c2], end =" " )
    print("")
    T+=1

