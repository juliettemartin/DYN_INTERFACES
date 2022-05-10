library(ggplot2)

Contact_Freq=read.table('contact_frequency.temp',sep=',')
colnames(Contact_Freq)=c('tag','l_residue','r_residue','relative_freq')

Residue_Freq=read.table('residue_frequency.temp',sep=',')
colnames(Residue_Freq)=c('tag','residue','nb_contacts')
         
Residue_keys=read.table('residue_keys.temp', sep=',')
colnames(Residue_keys)=c("side","index")

# reorder residue index 
# marche
Contact_Freq$l_residue=factor(Contact_Freq$l_residue, levels=Residue_keys[Residue_keys$side=='l_key',]$index)

Contact_Freq$r_residue=factor(Contact_Freq$r_residue, levels=Residue_keys[Residue_keys$side=='r_key',]$index)

ggplot(Contact_Freq,aes(l_residue,r_residue,fill=relative_freq))+geom_tile()+scale_fill_gradientn(colours = rev(terrain.colors(10)))+theme_bw()+theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
#+scale_fill_gradient(low="yellow",high="red")


