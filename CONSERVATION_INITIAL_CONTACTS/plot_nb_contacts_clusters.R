library(ggplot2)

# read and Jaccard data

# construct a symmetric matrix
input=scan("input.txt",what="e")
X=read.table(input[1],h=1)
#X$Delta_ASA=X$Delta_ASA/2


if (length(input)>1)
{
  
  # read external data: labels of the centroids 
  clusters=read.table(input[2])
  colnames(clusters)=c("Time","cluster")
  X=merge(X,clusters)
}else{
  X$cluster=1
}


# need to add group=1, otherwise the data is grouped by cluster, which is bad for the lines

pdf(width=4,height=3)

ggplot(X,aes(NB_contacts,col=as.factor(cluster)))+geom_density()+theme_bw()+labs(col="cluster")

dev.off()

M=aggregate(NB_contacts~cluster, data=X,mean)
S=aggregate(NB_contacts~cluster, data=X,sd)

write.table(file="mean.txt",M)
write.table(file="sd.txt",S)
