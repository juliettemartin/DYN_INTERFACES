# Juliette Martin, July 2021
# extract a snapshot from a concatenated file 

import argparse
import sys
import re
import os

# MODIFY this line according to your system
def args_gestion():
        parser = argparse.ArgumentParser(description = "A programm to extract a given snapshot from a concatenated" )
        parser.add_argument("--struct", metavar = "<file>", help = "Mandatory. Name of the PDB file to analyse", required=True)
        parser.add_argument("--time", metavar = "<int>", help = "Mandatory. Time wanted", default='None',required = True)
        return parser.parse_args()

# Read arguments 
ARGS = args_gestion()

flag="NO"

with open(ARGS.struct) as f:
        for line in f:
                if re.search("^TITLE",line):
                        T=line.split()[5].split('.')[0]
                        if T == ARGS.time:
                                flag="YES"
                        else:
                                flag="NO"
                if flag=="YES":
                        print(line.rstrip())
 