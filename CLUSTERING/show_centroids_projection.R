library(ggplot2)

# read and Jaccard data

# construct a symmetric matrix
input=scan("input.txt",what="e")
X=read.table(input[1],h=1)
X$Jaccard=X$NB_common/(X$NB_contacts1+X$NB_contacts2-X$NB_common)
X_reverse=X
X_reverse$Time1=X$Time2
X_reverse$Time2=X$Time1
X_sym=rbind(X,X_reverse)
# Add diagonal
Time_range=unique(X$Time1)
X_sym=rbind(X_sym,data.frame(Time1=Time_range,Time2=Time_range,NB_contacts1=NA,NB_contacts2=NA,NB_common=NA,Jaccard=1))
D=tapply(X_sym[,"Jaccard"],X_sym[,c("Time1","Time2")],c)
# add 1 in the last case
diag(D)=1

# read external data: labels of the centroids 
centroids_v1=scan(input[3],what="e")
centroids_v2=scan(input[4],what="e")

N=length(centroids_v1)

# project the Distances onto a 2D map 
loc=cmdscale(as.dist(1-D),eig=TRUE)
# I have some negative eigenvalues, because the matrix hs not the required properties...
# OK, I accept this is an approximation
# I will approximate the percentage of variance explained by jsut ignoring the negative eigen values
total_var=sum(loc$eig[which(loc$eig>0)])
var_expl=(loc$eig/total_var*100)[1:2]

my_data=data.frame(loc$points)
colnames(my_data)=c("x","y")
my_data$label=rownames(loc$points)

# perform clustering with the add hoc number of clusters
C=(cutree(hclust(as.dist(1-D),method="ward.D2"),k=N))
# add cluster label info in the projectopn
my_data$cluster=C
my_data$centroids_v1=ifelse(my_data$label%in%centroids_v1,"YES","NO")
my_data$centroids_v2=ifelse(my_data$label%in%centroids_v2,"YES","NO")

pdf(width=4,height=3)
ggplot(my_data,aes(x,y))+geom_path(col="grey")+geom_point(aes(col=as.factor(cluster)))+geom_point(data=my_data[1,],aes(x,y),col="red",size=2,shape=3,stroke=2)+geom_point(data=my_data[my_data$centroids_v2=="YES",],aes(x,y), col="black",size=2,shape=1,stroke=2)+geom_point(data=my_data[my_data$centroids_v1=="YES",],aes(x,y), col="purple",size=2,shape=1,stroke=2)+theme_bw()+labs(col="cluster")+xlab(paste("x, %var=",format(var_expl[1],digits=3)))+ylab(paste("x, %var=",format(var_expl[2],digits=3)))
dev.off()

pdf(width=4,height=3,file="ProjectionV2.pdf")
ggplot(my_data,aes(x,y))+geom_path(col="grey")+geom_point(aes(col=as.factor(cluster)))+geom_point(data=my_data[1,],aes(x,y),col="red",size=2,shape=3,stroke=2)+geom_point(data=my_data[my_data$centroids_v2=="YES",],aes(x,y), col="black",size=2,shape=1,stroke=2)+theme_bw()+labs(col="cluster")+xlab(paste("PC1, %var=",format(var_expl[1],digits=3)))+ylab(paste("PC2, %var=",format(var_expl[2],digits=3)))
dev.off()