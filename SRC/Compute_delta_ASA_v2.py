# Juliette Martin, January 2021
# detection of interface residues in a dimer
# require naccess

import argparse
import sys
import re
import os


# MODIFY this line according to your system

naccess_path='/Users/jmartin/SOFTS/naccess/naccess2.1.1/'

def args_gestion():
        parser = argparse.ArgumentParser(description = "A programm to detect protein-protein interface residues in a PDB file" )
        parser.add_argument("--struct", metavar = "<file>", help = "Mandatory. Name of the PDB file to analyse", required=True)
        parser.add_argument("--chains", metavar = "<str>", help = "[None]. Not mandatory. Name of protein chains used for the detection. Expected format: A,B (interface between chain A and B). More that two chains can be used, e.g.: AB,C for interface between AB and C. If not given, you should provide a PDB file with exactly 2 chains", default='None',required = False)
        parser.add_argument("--clean", metavar="<str>",help= "[True]. Not Mandatory. Delete intermediate files after execution. Set it to False if you want to keep then for inspection.",default="True",required=False)
        return parser.parse_args()

# Read arguments 
ARGS = args_gestion()
chain_list=[]

# Stop if temp files are already present in the directory
if os.system('ls temp* >/dev/null') == 0:
        print('******')
        print('Some temporary files have been detected:')
        os.system('ls temp* ')
        print('cannot append content to existing file: interrupting')
        print('******')
        sys.exit(1)

if ARGS.chains !='None':
        input_chain_list=ARGS.chains.split(',')
        if(len(input_chain_list)!=2):
                print('provide exactly two set of chains separated by a comma')
                sys.exit(1)
        else:
                left_chains=input_chain_list[0]
                right_chains=input_chain_list[1]


print('reading file '+ARGS.struct)

# If no chain name is provided, scan the file a first time to check the number of protein chains 
with open(ARGS.struct) as f:
        for line in f:
                if re.search("^ATOM",line) or re.search("^HETATM",line):
                        chain_name=line[21]
                        if not chain_name in chain_list:
                                chain_list.append(chain_name)

# Check that the correct number of chains is provided 
if len(chain_list) >2:
        if ARGS.chains=='None':
                print("more than two chains detected in the PDB file, and no chains specified in the command line")
                print(chain_list)
                print("please provide the chain names to define the interface ")
                sys.exit(1)
else:
        left_chains=chain_list[0]
        right_chains=chain_list[1]

print('detection of interface between '+str(left_chains)+' and '+str(right_chains))

with open(ARGS.struct) as f:
        print('splitting into different files')
        for line in f:
                if re.search("^ATOM",line) or re.search("^HETATM",line):
                        chain_name=line[21]
                        if chain_name in left_chains+right_chains:
                                with open('temp_all.pdb','a') as f:
                                        f.write(line)
                                if chain_name in list(left_chains):
                                        with open('temp_'+left_chains+'.pdb','a') as f:
                                                f.write(line)
                                if chain_name in right_chains:
                                        with open('temp_'+right_chains+'.pdb','a') as f:
                                                f.write(line)
                         
# Run naccess
print('running naccess on the files:')
for suffix in [left_chains,right_chains,'all']:
        filename='temp_'+suffix+'.pdb'
        print(filename)
        os.system(naccess_path+'naccess '+filename)

# post_process naccess files 
print('post_processing the results')
unbound_asa={}

for chain_name in chain_list:
        filename='temp_'+chain_name+'.rsa'
        with open(filename,'r') as f:
                for line in f:
                        if re.search("^TOTAL",line):
                                rsa=line.split()[1]
                                unbound_asa[chain_name]=float(rsa)

with open('temp_all.rsa','r') as f:
        for line in f:
                if re.search("^TOTAL",line):
                        rsa=line.split()[1]
                        bound_asa=float(rsa)

with open('result.txt','w') as f:
    f.write(str(unbound_asa[chain_list[0]])+' '+str(unbound_asa[chain_list[1]])+' '+str(bound_asa)+' '+str(unbound_asa[chain_list[0]]+unbound_asa[chain_list[1]]-bound_asa))

# clean temporary files 
if ARGS.clean=="True":
        print("cleaning temp file")
        for chain_name in [left_chains,right_chains,'all']:
                for ext in ['.pdb','.rsa','.asa','.log']:
                        filename='temp_'+chain_name+ext
                        os.system('rm -f '+filename)



