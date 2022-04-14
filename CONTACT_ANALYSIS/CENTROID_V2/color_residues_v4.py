# Color residues in representative structures
# Each contac is classified as fixed (=seen in all structures) or variable
# residues implied in MORE THAN  one variable contact are colored in red
# ONLY residues involved in contacts in EACH representative are shown as sticks
# residues of protein 1 are shown as sphere
# residues of protein 2 are shown as balls and sticks

import pickle
import argparse

def args_gestion():
        parser = argparse.ArgumentParser(description = "A programm to analyse contacts at interface during MD" )
        parser.add_argument("--pkl", metavar = "<file>", help = "Mandatory. Name of the pkl file to analyse", required=True)
        parser.add_argument("--index", metavar = "<file>", help = "Mandatory. Name of the file with the index of representative structures", required=True)
        parser.add_argument("--color",metavar="<character>",help= "optionnal. Color of residues involved in more that N changing contacts (default = red)",required=False,default="red")
        parser.add_argument("--N",metavar="<integer>",help= "optionnal. Treshold of changing contacts to color residues (default 1)",required=False,default=1)

        return parser.parse_args()
# Read arguments 
ARGS = args_gestion()


with open(ARGS.index, 'r') as file:
    my_indexes=(file.readlines()[0]).split()

#print(my_indexes)
# need to specify rb and not only r, otherwise I get an error 
# UnicodeDecodeError: 'utf-8' codec can't decode byte 0x80 in position 0: invalid start byte
with open(ARGS.pkl,'rb') as file:
    Contacts=pickle.load(file)

# Compute contact frequencies : number of times this contact is seen
# if this is a fixed contact (= appearing in every structures), his frequency equals the number of structures
C_Frequency={}
# lr = left residue, rr=right residues
lr_color={}
rr_color={}

# Here, I produce one list of interface residues per snapshot
interface_residues={}



for snapshot in my_indexes:
    #print(snapshot)
    interface_residues[snapshot]=[]
    for c in Contacts[snapshot]:
        #print(c)
        left_residue=c.split("/")[0]
        #print(left_residue)
        right_residue=c.split("/")[1]
        if not left_residue in lr_color.keys():
            lr_color[left_residue]="grey"
        if not right_residue in rr_color.keys():
            rr_color[right_residue]="grey"

        if not left_residue in interface_residues[snapshot]:
            interface_residues[snapshot].append(left_residue)
        if not right_residue in interface_residues[snapshot]:
            interface_residues[snapshot].append(right_residue)
           
        try:
            C_Frequency[c]+=1
        except:
            C_Frequency[c]=1
 
# Here, I produce a table, couting how many times each interface residue is seen. That allows to see which residues are always present at the interface, 
# and which residues are present only in some structures (labile residues)
reccurence_index={}
for snapshot in my_indexes:
    for r in interface_residues[snapshot]:
        try:
            reccurence_index[r]+=1
        except:
            reccurence_index[r]=1

labile_residues=[]
for key,val in reccurence_index.items():
    if val!=len(my_indexes):
        labile_residues.append(key)


# Here, I compute the frequency of the residues in changing contacts
R_Frequency={}

for key, value in C_Frequency.items():
    left_residue=key.split("/")[0]
    right_residue=key.split("/")[1]
    if value!=len(my_indexes):
        lr_color[left_residue]="red"
        rr_color[right_residue]="red"
        try:
            R_Frequency[left_residue]+=1
        except:
            R_Frequency[left_residue]=1
        try:
            R_Frequency[right_residue]+=1
        except:
            R_Frequency[right_residue]=1
    else:
        try:
            R_Frequency[left_residue]+=0
        except:
            R_Frequency[left_residue]=0
        try:
            R_Frequency[right_residue]+=0
        except:
            R_Frequency[right_residue]=0    

model_index=0
for snapshot in my_indexes:
    for c in Contacts[snapshot]:
        r_list=[]
        r_list=[]
        left_residue=c.split("/")[0]
        right_residue=c.split("/")[1]
        if not left_residue in r_list:
            r_list.append(left_residue)
        if not right_residue in r_list:
            r_list.append(right_residue)
        for r in r_list:
            index=r.split(" ")[1]
            chain=r.split(":")[1]

            if chain=="A":
                print("represent sphere #"+str(model_index)+":"+index+"."+chain)
                
            else:
                print("represent bs #"+str(model_index)+":"+index+"."+chain)
            print("display #"+str(model_index)+":"+index+"."+chain)
            if R_Frequency[r]>ARGS.N:
                print("color "+ARGS.color+" #"+str(model_index)+":"+index+"."+chain)
            if r in labile_residues:
                print("color yellow #"+str(model_index)+":"+index+"."+chain)
    model_index+=1


