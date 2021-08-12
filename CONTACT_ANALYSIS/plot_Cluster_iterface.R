library(ggplot2)
library(reshape2)

Contact_Freq=read.table('contact_frequency.temp',sep=',')
colnames(Contact_Freq)=c('tag','cluster','l_residue','r_residue','relative_freq')

Residue_Freq=read.table('residue_frequency.temp',sep=',')
colnames(Residue_Freq)=c('tag','cluster','residue','nb_contacts')
         
Residue_keys=read.table('residue_keys.temp', sep=',')
colnames(Residue_keys)=c("side","index")

# reorder residue index 
Contact_Freq$l_residue=factor(Contact_Freq$l_residue, levels=Residue_keys[Residue_keys$side=='l_key',]$index)

Contact_Freq$r_residue=factor(Contact_Freq$r_residue, levels=Residue_keys[Residue_keys$side=='r_key',]$index)

# plot contact matrix for each cluster
ggplot(Contact_Freq,aes(l_residue,r_residue,fill=relative_freq))+geom_tile()+scale_fill_gradientn(colours = rev(terrain.colors(10)))+theme_bw()+theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+facet_wrap(~cluster)
#+scale_fill_gradient(low="yellow",high="red")

#ggplot(Contact_Freq,aes(paste(l_residue,r_residue),relative_freq,fill=as.factor(cluster)))+theme_bw()+theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+geom_col(position="dodge")


# plot the variance of frequency in a different matrix 

# 1 convert long to wide to get zeros for unseen contacts
wide_contacts=dcast(Contact_Freq,l_residue+r_residue~cluster,value.var="relative_freq",fill=0)
# 2 reformat to long format
long_data=melt(wide_contacts, id.vars=c("l_residue","r_residue"),variable.name="cluster",value.name="relative_freq")

# 3 compute var of relative_freq
my_var=aggregate(relative_freq ~ l_residue+r_residue, data = long_data, var)
colnames(my_var)=c("l_residue","r_residue","var")
# plot var matrix 
ggplot(my_var,aes(l_residue,r_residue,fill=var))+geom_tile()+theme_bw()+theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+scale_fill_gradient(low="blue",high="red")

Summed_var_left_residues=aggregate(var ~ l_residue, data = my_var, sum)
Summed_var_left_residues$side="left"
colnames(Summed_var_left_residues)=c("index","var","side")

Summed_var_right_residues=aggregate(var ~ r_residue, data = my_var, sum)
Summed_var_right_residues$side="right"
colnames(Summed_var_right_residues)=c("index","var","side")

Contact_variability=rbind(Summed_var_left_residues,Summed_var_right_residues)

ggplot(Contact_variability,aes(index,var))+geom_col()+theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+facet_wrap(~side,ncol=1,scales = "free_x")

write.table(Summed_var_left_residues,file="var_left_residues.txt", quote=F,row.names=F,col.names=F)
write.table(Summed_var_right_residues,file="var_right_residues.txt", quote=F,row.names=F,col.names=F)


# plot pairs of clusters, and difference matrix between them
cluster_pairs=combn(unique(Contact_Freq$cluster),m=2)

for ( i in 1:dim(cluster_pairs)[2])
{
  my_pair=(cluster_pairs[,i])
  print(my_pair)
  my_contacts=Contact_Freq[Contact_Freq$cluster%in%my_pair,]

# melt long data into wide 
#> head(my_contacts)
#tag cluster l_residue r_residue relative_freq
#1 contact_frequency       1   LYS 91    HID 24      0.8565574
#2 contact_frequency       1   LYS 91    LEU 25      0.9754098



my_data=dcast(my_contacts,l_residue+r_residue~cluster,value.var="relative_freq",fill=0)

#> head(my_data)
#l_residue r_residue           1          2
#1   ALA 89    HID 24  0.340163934 0.53696498
#2   ALA 89    LEU 25  0.008196721 0.00000000

# Add absolute difference 
my_data[,"delta"]=abs(my_data["1"]-my_data["2"])

# Retransform wide data into long 
long_data=melt(my_data, id.vars=c("l_residue","r_residue"),variable.name="cluster",value.name="relative_freq")

#And plot it ! 
# plot contact matrix for each cluster
G=ggplot(long_data,aes(l_residue,r_residue,fill=relative_freq))+geom_tile()+scale_fill_gradientn(colours = rev(terrain.colors(10)))+theme_bw()+theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+facet_wrap(~cluster,ncol=2)
#+scale_fill_gradient(low="yellow",high="red")
print(G)
}