import ccmap

import pyproteinsExt.structure.coordinates as PDB
parser = PDB.Parser()

CUTOFF=5.0


with open("list_structures.temp") as file:
    lines=file.readlines()


pdbREC = parser.load(file=lines[0].split()[1])
pdbDictREC = pdbREC.atomDictorize
pdbDictREC.keys()

pdbLIG = parser.load(file=lines[0].split()[2])
pdbDictLIG = pdbLIG.atomDictorize
pdbDictLIG.keys()


initial_contacts=ccmap.cmap(pdbDictREC, pdbDictLIG, d=CUTOFF, encode=True)
initial_number=len(initial_contacts)

# boucler sur les snapshots suivants 
i=0
while i < len(lines):
    T=lines[i].split()[0]
    pdbREC = parser.load(file=lines[i].split()[1])
    pdbDictREC = pdbREC.atomDictorize

    pdbLIG = parser.load(file=lines[i].split()[2])
    pdbDictLIG = pdbLIG.atomDictorize

    current_contacts=ccmap.cmap(pdbDictREC, pdbDictLIG, d=CUTOFF, encode=True)
    common_contacts=len( [value for value in current_contacts if value in initial_contacts] )
    perc=common_contacts/initial_number
    print(T+' '+str(initial_number)+' '+str(len(current_contacts))+' '+str(common_contacts)+' '+str(perc))
    i=i+1

