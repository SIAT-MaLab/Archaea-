##Fig.2a Number of CRISPR spacers per host Genus
library(ggplot2)
library(rJava)
library(permute)
library(lattice)
library(vegan)
library(dplyr)
library(readxl)
library(tidyr)
library(gg.gap)
library(ggchicklet)
library(RColorBrewer)

df = read_excel("E:/HMP_Project/results_wang/20210326/1946古菌病毒与host匹配(20210526)/spacer对应古菌序列的分类(20210902).xlsx",sheet = 7,col_names = T)

df$Genus <- factor(df$Genus,levels = c("Methanobrevibacter_A smithii","Methanobrevibacter_A smithii_A",'Methanobrevibacter_A',
                                       "Methanosphaera","Methanomethylophilaceae",
                                       "Methanomassiliicoccus_A","Haloferax","Methanomassiliicoccus",
                                       "Methanobrevibacter","Methanomethylophilus",
                                       "Methanomethylophilaceae (UBA71)","Methanobacterium",
                                       "Methanobrevibacter_C","Methanoplasma","Nitrosopumilus"),ordered = TRUE)

stack_plot <- ggplot(df, aes(x = Genus, y = Spacers, fill = Species,label = Spacers))+
  geom_chicklet(position = 'stack',width = 0.3) +
  labs(x = 'Genus', y = 'The number of spacers')+
  theme_classic()+
  scale_fill_hue(c = 45,l = 80)+
  theme(axis.text.x = element_text(angle = 45, hjust = 1,face = "bold",size = 13),
        axis.text.y = element_text(size = 11),
        axis.title.x = element_text(face = "bold",size = 15,margin = margin(t = 5)),
        axis.title.y = element_text(face = "bold",size = 15,margin = margin(r = 25)),
        legend.text = element_text(face = "plain",family = "Times",colour = "black",size = 13),
        legend.title = element_text(face ="plain",family = "Times",colour = "black",size = 14),
        axis.line = element_line(color = "#3D4852"),
        axis.ticks = element_line(color = "#3D4852"))+
  geom_text(aes(label = Spacers),position = position_stack(vjust = 0.85),colour = "black")+
  theme(legend.position = c(0.8,0.7))
  
gg.gap(plot = stack_plot,
       segments = list(c(350,2500),c(2600,8000)),
       ylim = c(0,9000),
       rel_heights = c(0.1,0,0.01,0,0.01), 
       tick_width = c(50,100,500)) 
add.legend(plot = stack_plot,
           margin = c(top = 100,right = 100,bottom = 0.001,left = 50))
