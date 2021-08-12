import ccmap
import pickle
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