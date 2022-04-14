import ccmap
import pickle
#import pyproteinsExt.structure.coordinates as PDB
import pypstruct.coordinates as PDB
parser = PDB.Parser()

# need ccmap and pyproteinsext: 
# conda create -n test_contacts python=3.7
# pip install ccmap
# pip install pypstruct


CUTOFF=5.0


with open("list_structures.temp") as file:
    lines=file.readlines()

## example of list_structures.temp :
#0 rec0.pdb lig0.pdb
#1 rec1.pdb lig1.pdb
#2 rec2.pdb lig2.pdb
#3 rec3.pdb lig3.pdb
#4 rec4.pdb lig4.pdb
#5 rec5.pdb lig5.pdb
#6 rec6.pdb lig6.pdb
#7 rec7.pdb lig7.pdb
#8 rec8.pdb lig8.pdb
#9 rec9.pdb lig9.pdb


pdbREC = parser.load(file=lines[0].split()[1])
pdbDictREC = pdbREC.atomDictorize
pdbDictREC.keys()

pdbLIG = parser.load(file=lines[0].split()[2])
pdbDictLIG = pdbLIG.atomDictorize
pdbDictLIG.keys()

# boucle sur les snapshots suivants 
i=0
Interfaces={}
while i < len(lines):
    T=lines[i].split()[0]
    Interfaces[T]=[]
    pdbREC = parser.load(file=lines[i].split()[1])
    pdbDictREC = pdbREC.atomDictorize

    pdbLIG = parser.load(file=lines[i].split()[2])
    pdbDictLIG = pdbLIG.atomDictorize

    contacts=ccmap.cmap(pdbDictREC, pdbDictLIG, d=CUTOFF, encode=True)
    # les contacts sont codés sous forme d'entier.
    # Ids des résidus
    lig_residues=pdbLIG.getResID
    rec_residues=pdbREC.getResID

    # nombre de résidus, pour pouvoir décoder les contacts
    ligResCount = len(lig_residues)

    # décode les contacts
    indexes=[(int(i/ligResCount), i% ligResCount) for i in contacts ]
    for pair in indexes:
        rec_residue=rec_residues[pair[0]]
        lig_residue=lig_residues[pair[1]]
        Interfaces[T].append(rec_residue+"/"+lig_residue)
    i=i+1




print(Interfaces)

with open('Interfaces.pkl','wb') as file:
    pickle.dump(Interfaces,file)