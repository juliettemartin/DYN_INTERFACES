library(ggplot2)

# read and Jaccard data

# construct a symmetric matrix
input=scan("input.txt",what="e")
X=read.table(input[1],h=1)

# read external data: labels of the centroids 
clusters=read.table(input[2])
colnames(clusters)=c("T","cluster")

X=merge(X,clusters)

# need to add group=1, otherwise the data is grouped by cluster, which is bad for the lines

pdf(width=4,height=3)

ggplot(X,aes(Delta_ASA,col=as.factor(cluster)))+geom_density()+theme_bw()+labs(col="cluster")
ggplot(X,aes(T,Delta_ASA,col=as.factor(cluster)))+geom_line(aes(group=1))+labs(col="cluster")

ggplot(X,aes(T,ASA_A))+geom_line(col="orchid1")+geom_line(aes(T,ASA_B),col="burlywood")+geom_rug(sides="b",aes(col=as.factor(cluster)))+labs(col="cluster")

dev.off()

M=aggregate(cbind(Delta_ASA,ASA_A,ASA_B)~cluster, data=X,mean)
S=aggregate(cbind(Delta_ASA,ASA_A,ASA_B)~cluster, data=X,sd)

write.table(file="mean.txt",M)
write.table(file="sd.txt",S)
