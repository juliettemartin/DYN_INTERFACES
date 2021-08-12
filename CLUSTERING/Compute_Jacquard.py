import ccmap

import pyproteinsExt.structure.coordinates as PDB
parser = PDB.Parser()

CUTOFF=5.0


with open("list_structures.temp") as file:
    lines=file.readlines()


i=0
while i < len(lines):
    T1=lines[i].split()[0]
    pdbREC = parser.load(file=lines[i].split()[1])
    pdbDictREC = pdbREC.atomDictorize
    pdbLIG = parser.load(file=lines[i].split()[2])
    pdbDictLIG = pdbLIG.atomDictorize
    contacts_T1=ccmap.cmap(pdbDictREC, pdbDictLIG, d=CUTOFF, encode=True)

    j=i
    while j < len(lines):
        if j>i:
            T2=lines[j].split()[0]
            pdbREC = parser.load(file=lines[j].split()[1])
            pdbDictREC = pdbREC.atomDictorize
            pdbLIG = parser.load(file=lines[j].split()[2])
            pdbDictLIG = pdbLIG.atomDictorize
            contacts_T2=ccmap.cmap(pdbDictREC, pdbDictLIG, d=CUTOFF, encode=True)

            common_contacts=len( [value for value in contacts_T2 if value in contacts_T1] )
   
            print(T1+' '+T2+' '+str(len(contacts_T1))+' '+str(len(contacts_T2))+' '+str(common_contacts))
        j=j+1
    i=i+1
