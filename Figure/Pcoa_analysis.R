library(reshape2)
library(ggplot2)
library(rJava)
library(xlsx)
library(tidyr)
library(permute)
library(lattice)
library(vegan)
library(dplyr)
library(readxl)

#Anosim and Pcoa analysis based on gut archaea abundance
#Grouped by Gender 
df = read_excel("E:/HMP_Project/results_wang/soap_arc_20210601/all_12.arc_2948.species.metadata(20210710).xlsx",sheet=2,col_names = T)
df_Gender <- subset(df,Gender!="NA")
df_Gender1 <- df_Gender[,11:65]
df_Gender2 <- df_Gender1[which(rowSums(df_Gender1) > 0),]
row_index <- (rowSums(df_Gender1) > 0)
df_Gender3 <- df_Gender[row_index,]
dis_Gender <- vegdist(df_Gender3[,11:65],method = 'bray')


length(which(df_Gender$Gender == "M")) #641
length(which(df_Gender$Gender == "F")) #771

pcoa_Gender <- cmdscale(dis_Gender,k = 2, eig = T)
head(pcoa_Gender$points)
eig = pcoa_Gender$eig

df_Gender.ano <- with(df_Gender3, anosim(dis_Gender,Gender))
summary(df_Gender.ano)
plot(df_Gender.ano)
P = df_Gender.ano$signif
R = round(df_Gender.ano$statistic,3)

data = pcoa_Gender$points[,1:2]
data = data.frame(data)
colnames(data) = c('x','y')
type = df_Gender3$Gender
data = cbind(data,type)



p = ggplot(data, aes(x = x, y = y, color = type))+
  geom_point(alpha = .7, size = 2) +
  labs(x = paste("PCoA 1 (",format(100* eig[1] / sum(eig), digits = 4), "%)", sep = ""),
       y = paste("PCoA 2 (", format(100*eig[2] / sum(eig), digits = 4), "%)", sep = ""),
       title = "PCoA")

p + theme_classic() + stat_ellipse(type = "t", linetype = 2)+
  annotate("text",x = 0,y = 0.45,parse = TRUE,size = 8,label = paste('R:',R),family = "serif",fontface = "italic",colour = "darkred")+
  annotate("text",x = 0,y = 0.4,parse = TRUE,size = 8,label = paste('p:',P),family = "serif",fontface = "italic",colour = "darkred")+  scale_fill_hue(c = 45,l = 80)+
  theme(axis.text.x = element_text(face = "bold",size = 14),
        axis.text.y = element_text(face = "bold",size = 14),
        axis.title.x = element_text(face = "bold",size = 15,margin = margin(t = 20)),
        axis.title.y = element_text(face = "bold",size = 15,margin = margin(r = 20)),
        legend.text = element_text(face = "bold",family = "Arial",colour = "black",size = 14),
        legend.title = element_text(face = "bold",family = "Arial",colour = "black",size = 15),
        axis.line = element_line(color = "#3D4852"),
        axis.ticks = element_line(color = "#3D4852"))+
  theme(legend.position = c(0.8,0.9))


##Grouped by BMI 
df_BMI < -subset(df,BMI1! = "NA")
df_BMI1 <- df_BMI[,11:65]
df_BMI2 <- df_BMI1[which(rowSums(df_BMI1) > 0),]
row_index <- (rowSums(df_BMI1) > 0)
df_BMI3 <- df_BMI[row_index,]
dis_BMI <- vegdist(df_BMI3[,11:65],method = 'bray')


length(which(df_BMI3$BMI1 == "underweight")) 
length(which(df_BMI3$BMI1 == "normal"))  
length(which(df_BMI3$BMI1 == "overweight"))
length(which(df_BMI3$BMI1 == "obesity"))


library(ape)
pcoa_BMI <- cmdscale(dis_BMI,k = 2, eig = T)
head(pcoa_BMI$points)
eig = pcoa_BMI$eig 

df_BMI.ano <- with(df_BMI3, anosim(dis_BMI,BMI1))
summary(df_BMI.ano)
plot(df_BMI.ano)
P = df_BMI.ano$signif
R = round(df_BMI.ano$statistic,3)

data = pcoa_BMI$points[,1:2]
data = data.frame(data)
colnames(data)=c('x','y')
type = df_BMI3$BMI1
data = cbind(data,type)


p = ggplot(data, aes(x = x, y = y, color = type))+
  geom_point(alpha = .7, size = 2) +  
  labs(x = paste("PCoA 1 (",format(100* eig[1] / sum(eig), digits = 4), "%)", sep = ""),
       y = paste("PCoA 2 (", format(100*eig[2] / sum(eig), digits = 4), "%)", sep = ""),
       title = "PCoA")

p + theme_classic()+stat_ellipse(type = "t", linetype = 2)+  
  annotate("text",x = -0.7,y = 0.45,parse = TRUE,size = 8,label = paste('R:',R),family = "serif",fontface = "italic",colour = "darkred")+
  annotate("text",x = -0.7,y = 0.4,parse = TRUE,size = 8,label = paste('p:',P),family = "serif",fontface = "italic",colour = "darkred")+  scale_fill_hue(c = 45,l = 80)+
  theme(axis.text.x = element_text(face = "bold",size = 14),
        axis.text.y = element_text(face = "bold",size = 14),
        axis.title.x = element_text(face = "bold",size = 15,margin = margin(t = 20)),
        axis.title.y = element_text(face = "bold",size = 15,margin = margin(r = 20)),
        legend.text = element_text(face = "bold",family = "Arial",colour = "black",size = 14),
        legend.title = element_text(face = "bold",family = "Arial",colour = "black",size = 15),
        axis.line = element_line(color = "#3D4852"),
        axis.ticks = element_line(color = "#3D4852"))+
  theme(legend.position = c(0.902,0.9))
  
##Grouped by country(America & China,Tanzania) 
df_country <- subset(df,Country! = "NA")
df_tan_Nor_Afr <- filter(df_country,Country == "Tanzania"|Country == "China"|Country == "America")
index_China <- df_tan_Nor_Afr$Country == "China"
index_USA <- df_tan_Nor_Afr$Country == "America"
df_tan_Nor_Afr$Country[index_China] <- 'America & China'
df_tan_Nor_Afr$Country[index_USA] <- 'America & China'

df_tan_Nor_Afr1 <- df_tan_Nor_Afr[,11:65]
df_tan_Nor_Afr2 <- df_tan_Nor_Afr1[which(rowSums(df_tan_Nor_UK1) > 0),]
row_index <- (rowSums(df_tan_Nor_Afr1) > 0)
df_tan_Nor_Afr3 <- df_tan_Nor_Afr[row_index,]
dis_tan_Nor_Afr <- vegdist(df_tan_Nor_Afr3[,11:65],method = 'bray')

length(which(df_tan_Nor_Afr3$Country == "Tanzania")) #40

library(ape)
pcoa_tan_Nor_Afr <- cmdscale(dis_tan_Nor_Afr,k = 2, eig = T)
head(pcoa_tan_Nor_Afr$points) 
eig = pcoa_tan_Nor_Afr$eig 

df_tan_Nor_Afr.ano <- with(df_tan_Nor_Afr3, anosim(dis_tan_Nor_Afr,Country))
summary(df_tan_Nor_Afr.ano)
plot(df_tan_Nor_Afr.ano)
P = df_tan_Nor_Afr.ano$signif 
R = round(df_tan_Nor_Afr.ano$statistic,3) 

data = pcoa_tan_Nor_Afr$points[,1:2]
data = data.frame(data)
colnames(data) = c('x','y')
type = df_tan_Nor_Afr3$Country
data = cbind(data,type)

p = ggplot(data, aes(x = x, y = y, color = type))+  
  geom_point(alpha = .7, size = 2) +
  labs(x = paste("PCoA 1 (",format(100* eig[1] / sum(eig), digits = 4), "%)", sep = ""),  
       y = paste("PCoA 2 (", format(100*eig[2] / sum(eig), digits = 4), "%)", sep = ""),
       title = "PCoA")

p + theme_classic()+stat_ellipse(type = "t", linetype = 2)+
  annotate("text",x = -0.55,y = 0.4,parse = TRUE,size = 8,label = paste('R:',R),family = "serif",fontface = "italic",colour = "darkred")+
  annotate("text",x = -0.55,y = 0.35,parse = TRUE,size = 8,label = paste('p:',P),family = "serif",fontface = "italic",colour = "darkred")+  scale_fill_hue(c = 45,l = 80)+
  theme(axis.text.x = element_text(face = "bold",size = 14),
        axis.text.y = element_text(face = "bold",size = 14),
        axis.title.x = element_text(face = "bold",size = 15,margin = margin(t = 20)),
        axis.title.y = element_text(face = "bold",size = 15,margin = margin(r = 20)),
        legend.text = element_text(face = "bold",family = "Arial",colour = "black",size = 14),
        legend.title = element_text(face = "bold",family = "Arial",colour = "black",size = 15),
        axis.line = element_line(color = "#3D4852"),
        axis.ticks = element_line(color = "#3D4852"))+
  theme(legend.position = c(0.8,0.9))




###
##Anosim and Pcoa analysis based on gut archaeal virus abundance
##Grouped by Gender
df = read_excel("E:/HMP_Project/results_wang/soap_vir_20210510/all_12.vir_1280.metadata.xlsm",sheet=3,col_names = T)

df_Gender <- subset(df,Gender! = "NA")
df_Gender1 <- df_Gender[,12:1291]
df_Gender2 <- df_Gender1[which(rowSums(df_Gender1) > 0),]
row_index <- (rowSums(df_Gender1) > 0)
df_Gender3 <- df_Gender[row_index,]
dis_Gender <- vegdist(df_Gender3[,12:1291],method = 'bray')

length(which(df_Gender$Gender == "M")) #641
length(which(df_Gender$Gender == "F")) #771

pcoa_Gender <- cmdscale(dis_Gender,k = 2, eig = T)
head(pcoa_Gender$points)
eig <- pcoa_Gender$eig

df_Gender.ano <- with(df_Gender3, anosim(dis_Gender,Gender))
summary(df_Gender.ano)
plot(df_Gender.ano)
P = df_Gender.ano$signif
R = round(df_Gender.ano$statistic,3)

data = pcoa_Gender$points[,1:2]
data = data.frame(data)
colnames(data) = c('x','y')
type = df_Gender3$Gender
data = cbind(data,type)

p = ggplot(data, aes(x = x, y = y, color = type))+
  geom_point(alpha = .7, size = 2) +
  labs(x = paste("PCoA 1 (",format(100* eig[1] / sum(eig), digits = 4), "%)", sep = ""),
       y = paste("PCoA 2 (", format(100*eig[2] / sum(eig), digits = 4), "%)", sep = ""),
       title = "PCoA")

p + theme_classic()+stat_ellipse(type = "t", linetype = 2)+
  annotate("text",x = -0.4,y = 0.45,parse = TRUE,size = 8,label = paste('R:',R),family = "serif",fontface = "italic",colour = "darkred")+
  annotate("text",x = -0.4,y = 0.38,parse = TRUE,size = 8,label = paste('p:',P),family = "serif",fontface = "italic",colour = "darkred")+  scale_fill_hue(c = 45,l = 80)+
  theme(axis.text.x = element_text(face = "bold",size = 14),
        axis.text.y = element_text(face = "bold",size = 14),
        axis.title.x = element_text(face = "bold",size = 15,margin = margin(t = 20)),
        axis.title.y = element_text(face = "bold",size = 15,margin = margin(r = 20)),
        legend.text = element_text(face = "bold",family = "Arial",colour = "black",size = 14),
        legend.title = element_text(face = "bold",family = "Arial",colour = "black",size = 15),
        axis.line = element_line(color = "#3D4852"),
        axis.ticks = element_line(color = "#3D4852"))+
  theme(legend.position= c(0.91,0.9))

####Grouped by BMI
df_BMI <- subset(df,BMI1! = "NA")
df_BMI1 <- df_BMI[,12:1291]
df_BMI2 <- df_BMI1[which(rowSums(df_BMI1) > 0),]
row_index <- (rowSums(df_BMI1) > 0)
df_BMI3 <- df_BMI[row_index,]
dis_BMI <- vegdist(df_BMI3[,12:1291],method = 'bray')

length(which(df_BMI3$BMI1 == "underweight")) #20
length(which(df_BMI3$BMI1 == "normal"))  #322
length(which(df_BMI3$BMI1 == "overweight")) #277
length(which(df_BMI3$BMI1 == "obesity")) #100

library(ape)
res_BMI = pcoa(dis_BMI, correction = "none")
head(res_BMI$value)
biplot(res_BMI)
df.ano_BMI <- with(df_BMI3, anosim(dis_BMI,BMI1))
summary(df.ano_BMI)
plot(df.ano_BMI)

library(ggplot2)
P = df.ano_BMI$signif
R = round( df.ano_BMI$statistic,3)

data = res_BMI$vectors[,1:2]
data = data.frame(data)
colnames(data)=c('x','y')
eig = as.numeric(res_BMI$value[,1])

type = df_BMI3$BMI1
data = cbind(data,type)

p = ggplot(data, aes(x = x, y = y, color = type))+  
  geom_point(alpha = .7, size = 2) +
  labs(x = paste("PCoA 1 (",format(100* eig[1] / sum(eig), digits = 4), "%)", sep = ""),       
       y = paste("PCoA 2 (", format(100*eig[2] / sum(eig), digits = 4), "%)", sep = ""),   
       title = "PCoA")

p + theme_classic()+stat_ellipse(type = "t", linetype = 2)+  
  annotate("text",x = 0.004,y = -0.15,parse = TRUE,size = 4,label = paste('R:',R),family = "serif",fontface = "italic",colour = "darkred")+
  annotate("text",x = 0,y = -0.19,parse = TRUE,size = 4,label = paste('p:',P),family = "serif",fontface = "italic",colour = "darkred")

##Grouped by BMI
df_BMI <- subset(df,BMI1! = "NA")
df_BMI1 <- df_BMI[,12:1291]
df_BMI2 <- df_BMI1[which(rowSums(df_BMI1) > 0),]
row_index <- (rowSums(df_BMI1) > 0)
df_BMI3 <- df_BMI[row_index,]
dis_BMI <- vegdist(df_BMI3[,12:1291],method = 'bray')

length(which(df_BMI3$BMI1 == "underweight")) #21
length(which(df_BMI3$BMI1 == "normal"))  #322
length(which(df_BMI3$BMI1 == "overweight")) #277
length(which(df_BMI3$BMI1 == "obesity")) #100

library(ape)
pcoa_BMI <- cmdscale(dis_BMI,k = 2, eig = T)
head(pcoa_BMI$points) ##主坐标
eig = pcoa_BMI$eig ##特征根

df_BMI.ano <- with(df_BMI3, anosim(dis_BMI,BMI1))
summary(df_BMI.ano)
plot(df_BMI.ano)
P = df_BMI.ano$signif
R = round(df_BMI.ano$statistic,3)

data = pcoa_BMI$points[,1:2]
data = data.frame(data)
colnames(data) = c('x','y')
type = df_BMI3$BMI1
data = cbind(data,type)

p = ggplot(data, aes(x = x, y = y, color = type))+
  geom_point(alpha = .7, size = 2) +
  labs(x = paste("PCoA 1 (",format(100* eig[1] / sum(eig), digits = 4), "%)", sep = ""),  
       y = paste("PCoA 2 (", format(100*eig[2] / sum(eig), digits = 4), "%)", sep = ""),
       title = "PCoA")

p + theme_classic()+stat_ellipse(type = "t", linetype = 2)+
  annotate("text",x = -0.6,y = 0.5,parse = TRUE,size = 8,label = paste('R:',R),family = "serif",fontface = "italic",colour = "darkred")+
  annotate("text",x = -0.6,y = 0.43,parse = TRUE,size = 8,label = paste('p:',P),family = "serif",fontface = "italic",colour = "darkred")+  scale_fill_hue(c = 45,l = 80)+
  theme(axis.text.x = element_text(face = "bold",size = 14),
        axis.text.y = element_text(face = "bold",size = 14),
        axis.title.x = element_text(face = "bold",size = 15,margin = margin(t = 20)),
        axis.title.y = element_text(face = "bold",size = 15,margin = margin(r = 20)),
        legend.text = element_text(face ="bold",family = "Arial",colour = "black",size = 14),
        legend.title = element_text(face = "bold",family = "Arial",colour = "black",size = 15),
        axis.line = element_line(color = "#3D4852"),
        axis.ticks = element_line(color = "#3D4852"))+
  theme(legend.position = c(0.91,0.9))


##Grouped by country(America & China,Tanzania) 
df_country <- subset(df,Country! = "NA")
df_tan_Nor_Afr <- filter(df_country,Country == "Tanzania"|Country == "China"|Country == "America")
index_China <- df_tan_Nor_Afr$Country == "China"
index_USA <- df_tan_Nor_Afr$Country == "America"
df_tan_Nor_Afr$Country[index_China] <- 'America & China'
df_tan_Nor_Afr$Country[index_USA] <- 'America & China'

df_tan_Nor_Afr1 <- df_tan_Nor_Afr[,12:1291]
df_tan_Nor_Afr2 = df_tan_Nor_Afr1[which(rowSums(df_tan_Nor_UK1) > 0),]
row_index <- (rowSums(df_tan_Nor_Afr1) > 0)
df_tan_Nor_Afr3 <- df_tan_Nor_Afr[row_index,]
dis_tan_Nor_Afr <- vegdist(df_tan_Nor_Afr3[,12:1291],method = 'bray')

length(which(df_tan_Nor_Afr3$Country == "Tanzania")) 
length(which(df_tan_Nor_Afr3$Country == "America & China")) #715

library(ape)
pcoa_tan_Nor_Afr <- cmdscale(dis_tan_Nor_Afr,k = 2, eig = T)
head(pcoa_tan_Nor_Afr$points) 
eig = pcoa_tan_Nor_Afr$eig 

df_tan_Nor_Afr.ano <- with(df_tan_Nor_Afr3, anosim(dis_tan_Nor_Afr,Country))
summary(df_tan_Nor_Afr.ano)
plot(df_tan_Nor_Afr.ano)
P = df_tan_Nor_Afr.ano$signif 
R = round(df_tan_Nor_Afr.ano$statistic,3) 

data = pcoa_tan_Nor_Afr$points[,1:2]
data = data.frame(data)
colnames(data) = c('x','y')
type = df_tan_Nor_Afr3$Country
data = cbind(data,type)

p = ggplot(data, aes(x = x, y = y, color = type))+
  geom_point(alpha = .7, size = 2) +
  labs(x = paste("PCoA 1 (",format(100* eig[1] / sum(eig), digits = 4), "%)", sep = ""),      
       y = paste("PCoA 2 (", format(100*eig[2] / sum(eig), digits = 4), "%)", sep = ""),
       title = "PCoA")

p + theme_classic()+stat_ellipse(type = "t", linetype = 2)+
  annotate("text",x = -0.3,y = 0.65,parse = TRUE,size = 8,label = paste('R:',R),family = "serif",fontface = "italic",colour = "darkred")+
  annotate("text",x = -0.3,y = 0.6,parse = TRUE,size = 8,label = paste('p:',P),family = "serif",fontface = "italic",colour = "darkred")+
  scale_fill_hue(c = 45,l = 80)+
  theme(axis.text.x = element_text(face = "bold",size = 14),
        axis.text.y = element_text(face = "bold",size = 14),
        axis.title.x = element_text(face = "bold",size = 15,margin = margin(t = 20)),
        axis.title.y = element_text(face = "bold",size = 15,margin = margin(r = 20)),
        legend.text = element_text(face = "bold",family = "Arial",colour = "black",size = 14),
        legend.title = element_text(face = "bold",family ="Arial",colour = "black",size = 15),
        axis.line = element_line(color = "#3D4852"),
        axis.ticks = element_line(color = "#3D4852"))+
  theme(legend.position = c(0.8,0.9))
