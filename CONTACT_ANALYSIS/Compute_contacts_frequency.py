import pickle
import argparse

def args_gestion():
        parser = argparse.ArgumentParser(description = "A programm to analyse contacts at interface during MD" )
        parser.add_argument("--interface_file", metavar = "<file>", help = "Mandatory. Name of the pkl file to analyse", required=True)
        return parser.parse_args()
# Read arguments 
ARGS = args_gestion()

# need to specify rb and not only r, otherwise I get an error 
# UnicodeDecodeError: 'utf-8' codec can't decode byte 0x80 in position 0: invalid start byte
with open(ARGS.interface_file,'rb') as file:
    Contacts=pickle.load(file)
 
# lr = left residue, rr=right residues
lr_list=[]
rr_list=[]
# Compute the frequency of all the contacts in the snapshots
# C=contact
# R=residues
# This are Frequency tables 
C_Frequency={}
R_Frequency_left={}
R_Frequency_right={}

for snapshot in Contacts:
    for c in Contacts[snapshot]:
        left_residue=c.split("/")[0].split(":")[0]
        right_residue=c.split("/")[1].split(":")[0]
        if not left_residue in lr_list:
            lr_list.append(left_residue)
        if not right_residue in rr_list:
            rr_list.append(right_residue)

        try:
            C_Frequency[c]+=1
        except:
            C_Frequency[c]=1
        try:
            R_Frequency_left[left_residue]+=1
        except:
            R_Frequency_left[left_residue]=1
        try:
            R_Frequency_right[right_residue]+=1
        except:
            R_Frequency_right[right_residue]=1


for c in C_Frequency:
    left_residue=c.split("/")[0].split(":")[0]
    right_residue=c.split("/")[1].split(":")[0]
    print('contact_frequency,'+left_residue+','+right_residue+','+str(C_Frequency[c]/len(Contacts)))

# Another idea: print, for each residue, its total implication in contacts:
for c in R_Frequency_left:
    print('l_frequency,'+c+','+str(R_Frequency_left[c]/len(Contacts)))

for c in R_Frequency_right:
    print('r_frequency,'+c+','+str(R_Frequency_right[c]/len(Contacts)))


# avec la fonction sorted, je trie la liste selon une fonction que je définis:
# Ici: prendre le deuxième champ (numéro de résidu) et faire un tri numérique
new_list=(sorted(lr_list, key=lambda x: int(x.split()[1])))

for r in new_list:
    print('l_key,'+r)

new_list=(sorted(rr_list, key=lambda x: int(x.split()[1])))

for r in new_list:
    print('r_key,'+r)


