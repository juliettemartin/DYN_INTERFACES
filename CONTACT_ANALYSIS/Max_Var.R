X=read.table(file="Max_var_data.txt")

colnames(X)=c("index","index2","AA","res_index","Max_var","side","category")

X$VarCat=ifelse(round(X$Max_var,digits=2)>=0.2,"variable","stable")
  
library(ggplot2)



ggplot(X,aes(AA,fill=VarCat))+ stat_count(aes (y=..prop.., group=VarCat),position="dodge")

X$interCat="other"

X$interCat=ifelse(X$category=="core","core_support",X$interCat)
X$interCat=ifelse(X$category=="support","core_support",X$interCat)

table(X[X$VarCat=="variable","AA"])

table(X[X$VarCat=="stable","AA"])


ggplot(X,aes(AA,fill=interCat))+ stat_count(aes (y=..prop.., group=interCat),position="dodge")


X$AA=ifelse(X$AA=="CYX","CYS",as.character(X$AA))
X$AA=ifelse(X$AA=="HID","HIS",as.character(X$AA))
X$AA=ifelse(X$AA=="HIE","HIS",as.character(X$AA))
X$AA=ifelse(X$AA=="HIP","HIS",as.character(X$AA))

X$AA=ifelse(X$AA=="ASH","ASP",as.character(X$AA))
X$AA=ifelse(X$AA=="GLH","GLU",as.character(X$AA))

X=X[X$AA!="ACE",]


F1=table(X[X$VarCat=="stable","AA"])/sum(table(X[X$VarCat=="stable","AA"]))
F2=table(X[X$VarCat=="variable","AA"])/sum(table(X[X$VarCat=="variable","AA"]))


F3=merge(as.data.frame(F1),as.data.frame(F2), by="Var1",all=T)
colnames(F3)=c("AA","stable","variable")
F3$odd=F3$variable/F3$stable


