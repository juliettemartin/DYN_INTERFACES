# Color residues in representative structures
# Each contac is classified as fixed (=seen in all structures) or variable
# residues implied in MORE THAN  one variable contact are colored in red
# all residues involved in contacts in any representatives are shown as sticks

import pickle
import argparse

def args_gestion():
        parser = argparse.ArgumentParser(description = "A programm to analyse contacts at interface during MD" )
        parser.add_argument("--pkl", metavar = "<file>", help = "Mandatory. Name of the pkl file to analyse", required=True)
        parser.add_argument("--index", metavar = "<file>", help = "Mandatory. Name of the file with the index of representative structures", required=True)
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

for snapshot in my_indexes:
    #print(snapshot)
    for c in Contacts[snapshot]:
        #print(c)
        left_residue=c.split("/")[0]
        #print(left_residue)
        right_residue=c.split("/")[1]
        if not left_residue in lr_color.keys():
            lr_color[left_residue]="grey"
        if not right_residue in rr_color.keys():
            rr_color[right_residue]="grey"
        try:
            C_Frequency[c]+=1
        except:
            C_Frequency[c]=1
 

# Here, I compute the frequency of the residues involved in changing contacts
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

for r in lr_color.keys():
    #print(r)
    index=r.split(" ")[1]
    chain=r.split(":")[1]
    print("represent stick #*:"+index+"."+chain)
    print("display #*:"+index+"."+chain)   
    my_color="grey"
    if R_Frequency[r]>int(ARGS.N):
        my_color="red"
        print("color "+my_color+" #*:"+index+"."+chain)

for r in rr_color.keys():
    #print(r)
    index=r.split(" ")[1]
    chain=r.split(":")[1]
    print("represent stick #*:"+index+"."+chain)
    print("display #*:"+index+"."+chain)
    my_color="grey"
    if R_Frequency[r]>int(ARGS.N):
        my_color="red"
        print("color "+my_color+" #*:"+index+"."+chain)

#print(int(ARGS.N))
#print(lr_color)
#print(rr_color)

