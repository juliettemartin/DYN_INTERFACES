library(ggplot2)
pdf(width=4,height=3)
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

ggplot(X_sym,aes(Time1,Time2,fill=Jaccard))+geom_tile()+scale_fill_gradient(low="yellow",high="darkblue")+theme_bw()+xlab("Time (ns)")+ylab("Time (ns)")

D=tapply(X_sym[,"Jaccard"],X_sym[,c("Time1","Time2")],c)
# add 1 in the last case
diag(D)=1

plot(hclust(as.dist(1-D),method="ward.D2"),labels=FALSE,ann=FALSE,asp=1)

w_size=50

clusters=data.frame(N=numeric(),Time=numeric(),cluster=character())

data_mix=data.frame(N=numeric(),average=numeric(),min_size=numeric(),max_size=numeric(),nb_breaks=numeric(),s_time=numeric())

write("#Nb_clusters centroid Ids",file="centroids.txt",append=FALSE)
write("#Nb_clusters centroid Ids",file="centroids_start150.txt",append=FALSE)

for (N in c(2:50))
{
  C=(cutree(hclust(as.dist(1-D),method="ward.D2"),k=N))
  # for each cluster, get the distance matrix 
  if (N<10)
  {
  centroids=rep(NA,N)
  centroids_start150=rep(NA,N)
  for (n in c(1:N))
  {
    my_labels=which(C==n)
    d=D[my_labels,my_labels]
    # select the snapshot with max similarity to others 
    centroids[n]=names(which.max(rowSums(d)))
    centroids_start150[n]=centroids[n]
    
    while(as.numeric(centroids_start150[n])<150 & dim(d)[1]>2)
    {
      d=d[rownames(d)!=centroids_start150[n],colnames(d)!=centroids_start150[n]]
      centroids_start150[n]=names(which.max(rowSums(d)))
#      print(dim(d))
#      print(d)
    }
    if(as.numeric(centroids_start150[n])<150)
    {
      centroids_start150[n]=NA
    }
    
    
    
  }
  centroids=c(N,centroids)
  centroids_start150=c(N,centroids_start150)
  
  
  write(centroids,file="centroids.txt",append=TRUE,ncolumns=n+1)
  write(centroids_start150,file="centroids_start150.txt",append=TRUE,ncolumns=n+1)
  
  }
  
  clusters=rbind(clusters,data.frame(N=N,Time=as.numeric(names(C)),cluster=C))
  N_diff=NULL
  for (t in c(1:(length(C)-w_size)))
       {
         N_diff=c(N_diff,length(unique(C[t:(t+w_size)])))
        }

  # min(table(C)) : the size of the smallest cluster
  # max(table(C)) : the size of the largest cluster
  # length(which(C[2:length(C)]!=C[1:(length(C)-1)])) : number of breakpoints
  my_breaks=which(C[2:length(C)]!=C[1:(length(C)-1)])
  my_times=c(my_breaks,length(C))-c(0,my_breaks)
  
  # time spent in the same cluster for more than 10ns
  stability_time=sum(my_times[my_times>50])/sum(my_times)
  
  data_mix=rbind(data_mix,data.frame(N=N,average=mean(N_diff)/N,min_size=min(table(C)),max_size=max(table(C)),nb_breaks=length(which(C[2:length(C)]!=C[1:(length(C)-1)])),s_time=stability_time))
}

# changement de clusters par des couleurs
ggplot(clusters[clusters$N<10,],aes(Time,as.factor(N),fill=as.factor(cluster)))+geom_tile()+scale_fill_brewer(palette="Set1")+ylab("Nb(clusters)")+xlab("Time (ns)")+ labs(fill='Cluster')+theme_bw()

ggplot(data_mix[data_mix$N<=10,],aes(N,nb_breaks))+geom_line(col="red")+geom_point(col="red")+geom_line(aes(N,min_size),col="blue")+geom_point(aes(N,min_size),col="blue")+theme_bw()+geom_line(aes(N,max_size),col="orange")+geom_point(aes(N,max_size),col="orange")+xlab("Nb(clusters)")+ylab("cluster stability")+
  scale_colour_manual(values=c("red","green"))



# nombre moyen de clusters visités pendant 50ns ( proxy pour  nombre de changments )
ggplot(data_mix,aes(N,average))+geom_line()+geom_point()+ylab("<Nb of clusters visited in 50 ns> / Nb(cluster)")+xlab("Time")

ggplot(data_mix,aes(N,min_size))+geom_line()+geom_point()+ylab("cluster_size_range")+geom_line(aes(N,max_size))+geom_point(aes(N,max_size))

ggplot(data_mix,aes(N,nb_breaks))+geom_line()+geom_point()+ylab("number of cluster changes")

ggplot(data_mix,aes(N,100*s_time))+geom_line()+geom_point()+ylab("%Time spent in stable clusters (>50ns)")

library(reshape2)
data_mix2=melt(data_mix[,c("N","min_size","max_size","nb_breaks")],id.vars=c("N"),measure.bars=c("min_size,max_size,nb_breaks"))

ggplot(data_mix2[data_mix2$N<=10,],aes(N,value,col=variable))+geom_point()+geom_line()+xlab("Nb(clusters)")+ylab("Cluster stability")+theme_bw()+ labs(col='')

dev.off()
library(reshape2)
clusters_wide=acast(clusters[clusters$N<10,],Time~N,value.var="cluster")
write("#Snapshot cluster_labels(N=2) cluster_labels(N=3) ... cluster_labels(N=10)",file="clusters_wide.txt")
write.table(clusters_wide,file="clusters_wide.txt",col.names=FALSE,quote=FALSE,append=TRUE)


pdf(width=4,height=3,file="Membership.pdf")
ggplot(clusters[clusters$N<10,],aes(Time,as.factor(N),fill=as.factor(cluster)))+geom_tile()+scale_fill_brewer(palette="Set1")+ylab("Nb(clusters)")+xlab("Time (ns)")+ labs(fill='Cluster')+theme_bw()
dev.off()

pdf(width=4,height=3,file="Stability.pdf")
ggplot(data_mix2[data_mix2$N<=10,],aes(N,value,col=variable))+geom_point()+geom_line()+xlab("Nb(clusters)")+ylab("Cluster stability")+theme_bw()+ labs(col='')
dev.off()

pdf(width=4,height=4,file="hclust.pdf")
plot(hclust(as.dist(1-D),method="ward.D2"),labels=FALSE,sub="",main="",xlab="",asp=1)
dev.off()
