library(ggplot2)



my_data=data.frame(NULL)

for (protein in c("1PVH","3SGB","1FFW","1BRS","1EMV","1GCQ","2J0T","2OOB","1AK4","1AY7"))
{
  X=read.table(paste("Jacquard_index_",protein,".txt",sep=""),h=1)
  X$prot=protein
  my_data=rbind(my_data,X)
}

my_data$Jacquard=my_data$NB_common/(my_data$NB_contacts1+my_data$NB_contacts2-my_data$NB_common)

my_data_reverse=my_data
my_data_reverse$Time1=my_data$Time2
my_data_reverse$Time2=my_data$Time1

my_data_sym=rbind(my_data,my_data_reverse)

ggplot(my_data_sym,aes(Time1,Time2,fill=Jacquard))+geom_tile()+scale_fill_gradient(low="yellow",high="darkblue")+theme_bw()+facet_wrap(~prot)



ggplot(my_data_sym[my_data_sym$Time1<=300 & my_data_sym$Time2 <=300,],aes(Time1,Time2,fill=Jacquard))+geom_tile()+scale_fill_gradient(low="yellow",high="darkblue")+theme_bw()+facet_wrap(~prot)

ggplot(my_data,aes(Jacquard))+geom_density()+theme_bw()+facet_wrap(~prot)





