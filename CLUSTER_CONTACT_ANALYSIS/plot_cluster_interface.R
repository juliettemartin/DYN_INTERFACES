library(ggplot2)
library(reshape2)

APOLAR_CLASS=c("ALA","VAL","LEU","ILE","PRO","PHE","MET","TRP","GLY","CYS")

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

# Plot the repartition in contact class in each cluster 

# Variability as a function of contact type 
foo=function(x) return(strsplit(x," ")[[1]][1])
Contact_Freq$l_class=sapply(as.character(Contact_Freq$l_residue),foo)
Contact_Freq$r_class=sapply(as.character(Contact_Freq$r_residue),foo)

Contact_Freq$c_class="None"
Contact_Freq$c_class=ifelse(Contact_Freq$l_class%in%APOLAR_CLASS & Contact_Freq$r_class%in%APOLAR_CLASS,"apolar","mixed")
Contact_Freq$c_class=ifelse(!Contact_Freq$l_class%in%APOLAR_CLASS & !Contact_Freq$r_class%in%APOLAR_CLASS,"polar",Contact_Freq$c_class)


ggplot(Contact_Freq,aes(relative_freq,fill=c_class))+geom_histogram()+facet_wrap(~cluster)


A=aggregate(relative_freq ~ c_class+cluster, data = Contact_Freq, sum)


ggplot(A,aes(cluster,relative_freq,fill=c_class))+geom_col(col="black",position="fill")+ggtitle("contact types repartition")+ scale_fill_manual(values=c("white","grey","black"))

pdf(width=1.5,height=1.5,file="Boxplot.pdf")
ggplot(A,aes(as.factor(cluster),relative_freq,fill=c_class))+geom_col(col="black",position="fill")+ scale_fill_manual(values=c("white","grey","black"))+theme_bw()+theme(legend.position="None")+xlab("")+ylab('')
dev.off()

B=reshape(A,v.names="relative_freq",idvar="c_class",direction="wide",timevar="cluster")

chisq.test(B[,2:3])

# plot the variance of frequency in a different matrix 

# 1 convert long to wide to get zeros for unseen contacts
wide_contacts=dcast(Contact_Freq,l_residue+r_residue~cluster,value.var="relative_freq",fill=0)
# 2 reformat to long format
long_data=melt(wide_contacts, id.vars=c("l_residue","r_residue"),variable.name="cluster",value.name="relative_freq")

# 3 compute var of relative_freq
my_var=aggregate(relative_freq ~ l_residue+r_residue, data = long_data, var)
# average frequency over clusters
my_mean=aggregate(relative_freq ~ l_residue+r_residue, data = long_data, mean)
# max  frequency over clusters
my_max=aggregate(relative_freq ~ l_residue+r_residue, data = long_data, max)
colnames(my_max)=c("l_residue","r_residue","max_freq")

# min  frequency over clusters
my_min=aggregate(relative_freq ~ l_residue+r_residue, data = long_data, min)
colnames(my_min)=c("l_residue","r_residue","min_freq")


colnames(my_var)=c("l_residue","r_residue","var")
colnames(my_mean)=c("l_residue","r_residue","mean")

# plot var matrix 
ggplot(my_var,aes(l_residue,r_residue,fill=var))+geom_tile()+theme_bw()+theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+scale_fill_gradient(low="blue",high="red")+ggtitle("Variance of the contact frequency over clusters")



# Variability as a function of contact type 
foo=function(x) return(strsplit(x," ")[[1]][1])
my_var$l_class=sapply(as.character(my_var$l_residue),foo)
my_var$r_class=sapply(as.character(my_var$r_residue),foo)



my_var$class="None"
my_var$class=ifelse(my_var$l_class%in%APOLAR_CLASS & my_var$r_class%in%APOLAR_CLASS,"apolar","mixed")
my_var$class=ifelse(!my_var$l_class%in%APOLAR_CLASS & !my_var$r_class%in%APOLAR_CLASS,"polar",my_var$class)


ggplot(my_var,aes(var,fill=class))+geom_histogram(position="dodge")+ggtitle("Variability of contacts versus nature of residues")


# plot variability as a function of the minimum relative frequency for each cluster, colored by property
my_X=merge(my_var,my_min)
ggplot(my_X,aes(min_freq,var,col=class))+geom_point()

my_X=merge(my_var,my_max)
ggplot(my_X,aes(max_freq,var,col=class))+geom_point()


my_data=merge(my_var,my_max)

my_data$weighted_var=my_data$var*my_data$max_freq

ggplot(my_data,aes(weighted_var,fill=class))+geom_histogram(position="dodge")+ggtitle("Variability of contacts weighted by its max frequency versus nature of residues")





# plot mean matrix 
ggplot(my_mean,aes(l_residue,r_residue,fill=mean))+geom_tile()+theme_bw()+theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+scale_fill_gradient(low="blue",high="red")+ggtitle("Average frequency over clusters (unweighted)")

my_data=merge(my_mean,my_var)
my_data$product=my_data$mean*my_data$var

ggplot(my_data,aes(l_residue,r_residue,fill=product))+geom_tile()+theme_bw()+theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+scale_fill_gradient(low="blue",high="red")+ggtitle("Variance * Unweighted average")

Summed_var_left_residues=aggregate(var ~ l_residue, data = my_var, sum)
Summed_var_left_residues$side="left"
colnames(Summed_var_left_residues)=c("index","summed_var","side")

Summed_var_right_residues=aggregate(var ~ r_residue, data = my_var, sum)
Summed_var_right_residues$side="right"
colnames(Summed_var_right_residues)=c("index","summed_var","side")

Contact_variability=rbind(Summed_var_left_residues,Summed_var_right_residues)

ggplot(Contact_variability,aes(index,summed_var))+geom_col()+theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+facet_wrap(~side,ncol=1,scales = "free_x")

write.table(Summed_var_left_residues,file="summed_var_left_residues.txt", quote=F,row.names=F,col.names=F)
write.table(Summed_var_right_residues,file="summed_var_right_residues.txt", quote=F,row.names=F,col.names=F)

# For each residue: get the Maximum variance
# Get the min_maxFrequency
# biplot 
Max_var_left_residues=aggregate(var ~ l_residue, data = my_var, max)
Max_var_left_residues$side="left"
colnames(Max_var_left_residues)=c("index","max_var","side")

# prend la fréquence la plus grande observée dans chaque cluster
# par ex si le résidu est vu 100% du temps en interaction avec X et 35% du temps avec Y dans le cluster 1, on retient 100%
X1=aggregate(relative_freq ~ l_residue+cluster, data = long_data, max)
# ici, entre les clusters, on retient la plus petite fréquence, donc si dans un cluster il est vu au plus 100% et dans un autre au plus 58%, on retient 58%
X2=aggregate(relative_freq~l_residue,data=X1,min)

colnames(X2)=c("index","recurrence")
data_left=merge(Max_var_left_residues,X2)


Max_var_right_residues=aggregate(var ~ r_residue, data = my_var, max)
Max_var_right_residues$side="right"
colnames(Max_var_right_residues)=c("index","max_var","side")
X1=aggregate(relative_freq ~ r_residue+cluster, data = long_data, max)
X2=aggregate(relative_freq~r_residue,data=X1,min)

colnames(X2)=c("index","recurrence")
data_right=merge(Max_var_right_residues,X2)

write.table(Max_var_left_residues,file="max_var_left_residues.txt", quote=F,row.names=F,col.names=F)
write.table(Max_var_right_residues,file="max_var_right_residues.txt", quote=F,row.names=F,col.names=F)



data_both=rbind(data_right,data_left)
write.table(data_both,file="max_var_versus_recurrence.txt",quote=F,row.names=F,col.names=T)

foo=function(x) return(strsplit(x," ")[[1]][1])
data_both$res_name=sapply(as.character(data_both$index),foo)

data_both$class="None"
data_both$class=ifelse(data_both$res_name%in%c("ALA","VAL","LEU","ILE","PRO","PHE","MET","TRP","GLY","CYS"),"apolar","polar")


ggplot(data_both,aes(recurrence,max_var,label=index,col=side))+geom_text()+xlab("persistance index")+ylab("Contact variability")
ggplot(data_both,aes(recurrence,max_var,label=index,col=class))+geom_text()+xlab("persistance index")+ylab("Contact variability")+facet_wrap(~side)


ggplot(data_both,aes(recurrence,max_var,label=index,col=class,shape=side))+geom_text()+xlab("persistance index")+ylab("Contact variability")+ggtitle("both sides")


ggplot(data_both,aes(recurrence,max_var,label=index,col=class,shape=side))+geom_point()+xlab("persistance index")+ylab("Contact variability")


ggplot(data_both,aes(max_var,fill=class))+geom_histogram(position="dodge")+facet_wrap(~side,ncol=1)




ggplot(data_both,aes(index,max_var,fill=recurrence))+geom_col()+theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+facet_wrap(~side,ncol=1,scales = "free_x")+scale_fill_gradientn(colours = rev(heat.colors(10)))


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