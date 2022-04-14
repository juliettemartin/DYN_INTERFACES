import pickle
import argparse

def args_gestion():
        parser = argparse.ArgumentParser(description = "A programm to analyse contacts at interface during MD" )
        parser.add_argument("--pkl", metavar = "<file>", help = "Mandatory. Name of the pkl file to analyse", required=True)
        parser.add_argument("--index", metavar = "<file>", help = "Mandatory. Name of the file with the index of representative structures", required=True)
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

# Compute contact frequencies
C_Frequency={}

for snapshot in my_indexes:
    #print(snapshot)
    for c in Contacts[snapshot]:
        #
        #

        try:
            C_Frequency[c]+=1
        except:
            C_Frequency[c]=1
 

for key, value in C_Frequency.items():
    if value==len(my_indexes):
        my_color="blue"
    else:
        my_color="red"
    left_index=(key.split("/")[0]).split()[1]
    left_chain=(key.split("/")[0]).split()[2].split(':')[1]
    right_index=(key.split("/")[1]).split()[1]
    right_chain=(key.split("/")[1]).split()[2].split(':')[1]
 
    print("findclash  #*:"+left_index+"."+left_chain+" test  #*:"+right_index+"."+right_chain+" overlapCutoff -0.4 hbondAllowance 0 makePseudobonds true pbColor "+my_color+" reveal true")


