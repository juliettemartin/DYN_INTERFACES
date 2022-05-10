import pickle
import argparse

def args_gestion():
        parser = argparse.ArgumentParser(description = "A programm to analyse contacts at interface during MD" )
        parser.add_argument("--interface_file", metavar = "<file>", help = "Mandatory. Name of the pkl file to analyse", required=True)
        parser.add_argument("--cluster_file", metavar = "<file>", help = "Mandatory. Name of the file describing the different clusters", required=True)
        parser.add_argument("--nb", metavar = "<int>", help = "Mandatory. Number of clusters ",required = True)
        return parser.parse_args()
# Read arguments 
ARGS = args_gestion()

# Read the file describing the clusters
# #Snapshot cluster_labels(N=2) cluster_labels(N=3) ... cluster_labels(N=10)
#0 1 1 1 1 1 1 1 1
#1 2 2 2 2 2 2 2 2
#2 1 1 1 1 1 1 1 1
#3 1 1 1 1 3 3 3 3
# Line 1 = comment
# Then on each line: snapshot id , cluster_label with 2 clusters, cluster label with 3 clusters, etc
NbClus=int(ARGS.nb)
# why I need to cast to integer ?
Cluster_labels={}

with open(ARGS.cluster_file,'r') as file:
    lines=file.readlines()
    # skip first line
    for l in lines:
        if not "#" in l:
            words=l.split()
            try:
                Cluster_labels[words[0]].append(words[1:])
            except:
                Cluster_labels[words[0]]=words[1:]
#print(Cluster_labels)
# for snapshot s and number of clusters nc, the cluster label is :
# Cluster_labels[s][nc-2]


# need to specify rb and not only r, otherwise I get an error 
# UnicodeDecodeError: 'utf-8' codec can't decode byte 0x80 in position 0: invalid start byte
with open(ARGS.interface_file,'rb') as file:
    Contacts=pickle.load(file)
 
#print(Contacts)

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
Cluster_size={}

for snapshot in Contacts:
    label=Cluster_labels[snapshot][NbClus-1]
    try:
        Cluster_size[label]+=1
    except:
        Cluster_size[label]=1


    try: 
        C_Frequency[label]
    except:
        C_Frequency[label]={}

    try: 
        R_Frequency_right[label]
    except:
        R_Frequency_right[label]={}

    try: 
        R_Frequency_left[label]
    except:
        R_Frequency_left[label]={}

    for c in Contacts[snapshot]:
        left_residue=c.split("/")[0].split(":")[0]
        right_residue=c.split("/")[1].split(":")[0]
        if not left_residue in lr_list:
            lr_list.append(left_residue)
        if not right_residue in rr_list:
            rr_list.append(right_residue)

        try:
            C_Frequency[label][c]+=1
        except:
            C_Frequency[label][c]=1
        try:
            R_Frequency_left[label][left_residue]+=1
        except:
            R_Frequency_left[label][left_residue]=1
        try:
            R_Frequency_right[label][right_residue]+=1
        except:
            R_Frequency_right[label][right_residue]=1

for label in Cluster_size:

    for c in C_Frequency[label]:
        left_residue=c.split("/")[0].split(":")[0]
        right_residue=c.split("/")[1].split(":")[0]
        print('contact_frequency,'+label+','+left_residue+','+right_residue+','+str(C_Frequency[label][c]/Cluster_size[label]))

    for c in R_Frequency_left[label]:
        print('l_frequency,'+label+','+c+','+str(R_Frequency_left[label][c]/Cluster_size[label]))

    for c in R_Frequency_right[label]:
        print('r_frequency,'+label+','+c+','+str(R_Frequency_right[label][c]/Cluster_size[label]))


# avec la fonction sorted, je trie la liste selon une fonction que je définis:
# Ici: prendre le deuxième champ (numéro de résidu) et faire un tri numérique
new_list=(sorted(lr_list, key=lambda x: int(x.split()[1])))

for r in new_list:
    print('l_key,'+r)

new_list=(sorted(rr_list, key=lambda x: int(x.split()[1])))

for r in new_list:
    print('r_key,'+r)
