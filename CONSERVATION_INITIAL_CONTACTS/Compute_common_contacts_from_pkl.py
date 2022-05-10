import pickle
import argparse

def args_gestion():
        parser = argparse.ArgumentParser(description = "A programm to compute the number of interface contacts preserved during MD" )
        parser.add_argument("--interface_file", metavar = "<file>", help = "Mandatory. Name of the pkl file to analyse", required=True)
        return parser.parse_args()
# Read arguments 
ARGS = args_gestion()

with open(ARGS.interface_file,'rb') as file:
    All_contacts=pickle.load(file)

initial_contacts=All_contacts['0']
initial_number=len(initial_contacts)

# boucler sur les snapshots suivants 
for T in All_contacts:
    #print(T)
    current_contacts=All_contacts[T]
    #print(current_contacts)
    common_contacts=len( [value for value in current_contacts if value in initial_contacts] )
    perc=common_contacts/initial_number
    print(T+' '+str(initial_number)+' '+str(len(current_contacts))+' '+str(common_contacts)+' '+str(perc))


