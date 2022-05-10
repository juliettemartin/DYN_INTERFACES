import pickle
import argparse

def args_gestion():
        parser = argparse.ArgumentParser(description = "A programm to compute the Jaccard index based on contacts during MD" )
        parser.add_argument("--interface_file", metavar = "<file>", help = "Mandatory. Name of the pkl file to analyse", required=True)
        return parser.parse_args()
# Read arguments 
ARGS = args_gestion()

with open(ARGS.interface_file,'rb') as file:
    All_contacts=pickle.load(file)

i=0
for T1 in All_contacts: 
    contacts_T1=All_contacts[T1]
    j=0
    for T2 in All_contacts: 
        if j>i:
            contacts_T2=All_contacts[T2]
            common_contacts=len( [value for value in contacts_T2 if value in contacts_T1] )
            print(T1+' '+T2+' '+str(len(contacts_T1))+' '+str(len(contacts_T2))+' '+str(common_contacts))
        j=j+1
    i=i+1
