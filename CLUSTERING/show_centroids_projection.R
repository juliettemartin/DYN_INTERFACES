library(ggplot2)

input=scan("input.txt",what="e")
X=read.table(input[1],h=1)
X$Jaccard=X$NB_common/(X$NB_contacts1+X$NB_contacts2-X$NB_common)

X_reverse=X
X_reverse$Time1=X$Time2
X_reverse$Time2=X$Time1

X_sym=rbind(X,X_reverse)


centroids=scan(input[3],what="e")
# Add diagonal

Time_range=unique(X$Time1)
X_sym=rbind(X_sym,data.frame(Time1=Time_range,Time2=Time_range,NB_contacts1=NA,NB_contacts2=NA,NB_common=NA,Jaccard=1))

D=tapply(X_sym[,"Jaccard"],X_sym[,c("Time1","Time2")],c)
# add 1 in the last case
diag(D)=1

N=length(centroids)

C=(cutree(hclust(as.dist(1-D),method="ward.D2"),k=N))
# for each cluster, get the distance matrix 


loc=cmdscale(as.dist(1-D))
colnames(loc)=c("x","y")

my_data=data.frame(loc)

my_data$label=rownames(loc)
my_data$cluster=C
my_data$centroids=ifelse(my_data$label%in%centroids,"YES","NO")

ggplot(my_data,aes(x,y))+geom_path(col="grey")+geom_point(aes(col=as.factor(cluster)))+geom_point(data=my_data[1,],aes(x,y),col="red",size=2,shape=3,stroke=2)+geom_point(data=my_data[my_data$centroids=="YES",],aes(x,y), col="red",size=2,shape=1,stroke=2)


