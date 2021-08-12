library(ggplot2)

input=scan("input.txt",what="e")
X=read.table(input[1],h=1)


ggplot(X,aes(Time,Fraction_common))+geom_line()+ylim(0,1)+ggtitle(input[2])


ggplot(X,aes(Time,NB_contacts,col="current"))+geom_line()+ggtitle(input[2])+geom_line(aes(Time,NB_common,col="initial"))

