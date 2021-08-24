library(ggplot2)

# construct a symmetric matrix
input=scan("input.txt",what="e")
X=read.table(input[1],h=1)


X2=read.table(input[2],h=1)
X=merge(X,X2)

X$Delta_ASA=X$Delta_ASA/2
# read external data: labels of the centroids 

if (length(input)>2)
{
  
  # read external data: labels of the centroids 
  clusters=read.table(input[3])
  colnames(clusters)=c("T","cluster")
  X=merge(X,clusters)
}else{
  X$cluster=1
}

X$Gap_index=X$Gap_vol/X$Delta_ASA

# need to add group=1, otherwise the data is grouped by cluster, which is bad for the lines

pdf(width=4,height=3)

ggplot(X,aes(Gap_vol,col=as.factor(cluster)))+geom_density()+theme_bw()+labs(col="cluster")

dev.off()

pdf(width=4,height=3,file="Index.pdf")

ggplot(X,aes(Gap_index,col=as.factor(cluster)))+geom_density()+theme_bw()+labs(col="cluster")

dev.off()


M=aggregate(cbind(Gap_vol,Gap_index)~cluster, data=X,mean)
S=aggregate(cbind(Gap_vol,Gap_index)~cluster, data=X,sd)

write.table(file="mean.txt",M)
write.table(file="sd.txt",S)
