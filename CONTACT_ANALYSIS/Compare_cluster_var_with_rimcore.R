library(ggplot2)
library(reshape2)

Contact_Freq=read.table('contact_frequency.temp',sep=',')
colnames(Contact_Freq)=c('tag','cluster','l_residue','r_residue','relative_freq')

Residue_Freq=read.table('residue_frequency.temp',sep=',')
colnames(Residue_Freq)=c('tag','cluster','residue','nb_contacts')
         
Residue_keys=read.table('residue_keys.temp', sep=',')
colnames(Residue_keys)=c("side","index")

Interface_description=read.table('interface.temp',sep=',')
colnames(Interface_description)=c("side","index","l_category")


Contact_Freq=merge(Contact_Freq,Interface_description[Interface_description$side=="A",c("index","l_category")],by.x="l_residue",by.y="index")

colnames(Interface_description)=c("side","index","r_category")
Contact_Freq=merge(Contact_Freq,Interface_description[Interface_description$side=="B",c("index","r_category")],by.x="r_residue",by.y="index")



# reorder residue index 
Contact_Freq$l_residue=factor(Contact_Freq$l_residue, levels=Residue_keys[Residue_keys$side=='l_key',]$index)
Contact_Freq$r_residue=factor(Contact_Freq$r_residue, levels=Residue_keys[Residue_keys$side=='r_key',]$index)


# compute the sd of frequency in a different matrix 

# 1 convert long to wide to get zeros for unseen contacts
wide_contacts=dcast(Contact_Freq,l_residue+r_residue~cluster,value.var="relative_freq",fill=0)
# 2 reformat to long format
long_data=melt(wide_contacts, id.vars=c("l_residue","r_residue"),variable.name="cluster",value.name="relative_freq")

# 3 compute sd of relative_freq
Contact_var=aggregate(relative_freq ~ l_residue+r_residue, data = long_data, var)
colnames(Contact_var)=c("l_residue","r_residue","var")

Summed_var_left_residues=aggregate(var ~ l_residue, data = Contact_var, sum)
Summed_var_left_residues$side="left"
colnames(Summed_var_left_residues)=c("index","var","side")
colnames(Interface_description)=c("side","index","category")
Summed_var_left_residues=merge(Summed_var_left_residues,Interface_description[Interface_description$side=="A",c("index","category")],by="index")


Summed_var_right_residues=aggregate(var ~ r_residue, data = Contact_var, sum)
Summed_var_right_residues$side="right"
colnames(Summed_var_right_residues)=c("index","var","side")
colnames(Interface_description)=c("side","index","category")
Summed_var_right_residues=merge(Summed_var_right_residues,Interface_description[Interface_description$side=="B",c("index","category")],by="index")


write.table(Summed_var_left_residues[order(Summed_var_left_residues$var,decreasing=TRUE),],file="Summed_var_left_residues.txt",quote=F)

write.table(Summed_var_right_residues[order(Summed_var_right_residues$var,decreasing=TRUE),],file="Summed_var_right_residues.txt",quote=F)


# Same with max instead of Summed 
Max_var_left_residues=aggregate(var ~ l_residue, data = Contact_var, max)
Max_var_left_residues$side="left"
colnames(Max_var_left_residues)=c("index","var","side")
colnames(Interface_description)=c("side","index","category")
Max_var_left_residues=merge(Max_var_left_residues,Interface_description[Interface_description$side=="A",c("index","category")],by="index")


Max_var_right_residues=aggregate(var ~ r_residue, data = Contact_var, max)
Max_var_right_residues$side="right"
colnames(Max_var_right_residues)=c("index","var","side")
colnames(Interface_description)=c("side","index","category")
Max_var_right_residues=merge(Max_var_right_residues,Interface_description[Interface_description$side=="B",c("index","category")],by="index")


write.table(Max_var_left_residues[order(Max_var_left_residues$var,decreasing=TRUE),],file="Max_var_left_residues.txt",quote=F)

write.table(Max_var_right_residues[order(Max_var_right_residues$var,decreasing=TRUE),],file="Max_var_right_residues.txt",quote=F)




By_res_Contact_variability=rbind(Summed_var_left_residues,Summed_var_right_residues)

ggplot(By_res_Contact_variability,aes(index,var,fill=category))+geom_col()+theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+facet_wrap(~side,ncol=1,scales = "free_x")


# reorder by decreasing variablity
Summed_var_right_residues=Summed_var_right_residues[sort(Summed_var_right_residues$var,decreasing=T,index.return=T)$ix,]
Summed_var_right_residues$index=factor(Summed_var_right_residues$index,levels=Summed_var_right_residues$index)


Summed_var_left_residues=Summed_var_left_residues[sort(Summed_var_left_residues$var,decreasing=T,index.return=T)$ix,]
Summed_var_left_residues$index=factor(Summed_var_left_residues$index,levels=Summed_var_left_residues$index)

By_res_Contact_variability=rbind(Summed_var_left_residues,Summed_var_right_residues)

ggplot(By_res_Contact_variability,aes(index,var,fill=category))+geom_col()+theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+facet_wrap(~side,ncol=1,scales = "free_x")



# Add residue categories 
colnames(Interface_description)=c("side","index","l_category")
Contact_var=merge(Contact_var,Interface_description[Interface_description$side=="A",c("index","l_category")],by.x="l_residue",by.y="index")

colnames(Interface_description)=c("side","index","r_category")
Contact_var=merge(Contact_var,Interface_description[Interface_description$side=="B",c("index","r_category")],by.x="r_residue",by.y="index")

# Créé le label pour décrire le contact
Contact_var$c_category=ifelse(as.character(Contact_var$l_category)<as.character(Contact_var$r_category),paste(Contact_var$l_category,Contact_var$r_category),paste(Contact_var$r_category,Contact_var$l_category))

# Et maintenant, calcule la variability observée dans chaque catégorie 
Tab_A=aggregate(var ~ c_category, data = Contact_var, mean)
Tab_A=Tab_A[sort(Tab_A$var,index.return=TRUE,decreasing=TRUE)$ix,]

write.table(Tab_A,"average_var_by_contact_category.txt")

# Figure
Tab_A$cat1=unlist(lapply(Tab_A$c_category,function(x) strsplit(as.character(x)," ")[[1]][1]))
Tab_A$cat2=unlist(lapply(Tab_A$c_category,function(x) strsplit(as.character(x)," ")[[1]][2]))

# Symmetruze
Tab_B=Tab_A
Tab_B$cat1=Tab_A$cat2
Tab_B$cat2=Tab_A$cat1

Tab_sym=rbind(Tab_A,Tab_B)
ggplot(Tab_sym,aes(cat1,cat2,fill=var))+geom_tile()+theme_bw()+theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+scale_fill_gradient(low="blue",high="red")



