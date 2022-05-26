#Fig. 4a: Number of archaeal viral contigs per host class
library(gg.gap)
library(ggplot2)
data <- data.frame(x = c("Methanobrevibacter_A",
                   "Methanobrevibacter",
                   "Methanomassiliicoccus",
                   "Methanosphaera",
                   "Methanomethylophilaceae UBA71",
                   "Methanomassiliicoccus_A",
                   "Haloferax",
                   "Methanobrevibacter_C"),
             y = c(1217,19,16,9,9,6,2,1))

data$x <- factor(data$x,levels = c("Methanobrevibacter_A",
                                    "Methanobrevibacter",
                                    "Methanomassiliicoccus",
                                    "Methanosphaera",
                                    "Methanomethylophilaceae UBA71",
                                    "Methanomassiliicoccus_A",
                                    "Haloferax",
                                    "Methanobrevibacter_C") ,

p1 = ggplot(data, aes(x = x, y = y)) +
  geom_bar(stat = 'identity', position = position_dodge(),show.legend = FALSE) +
  labs(x = 'Host Taxonomy (Genus level)', y = 'The number of viral contigs')+
  theme_classic()+
  geom_col(fill = "#4472C4")+
  #scale_fill_hue(c = 45,l = 80)+
  #scale_fill_brewer(palette = "PiYG")+
  theme(axis.text.x = element_text(angle = 45, hjust = 1,face = "bold",size = 11,colour = "black"),
        axis.text.y = element_text(size = 11,colour = "black"),
        axis.title.x = element_text(face = "bold",size = 12,margin = margin(t = 8)),
        axis.title.y = element_text(face = "bold",size = 12,margin = margin(r = 15)),
        legend.text = element_text(face = "plain",family ="Arial",colour = "black",size = 10),
        axis.line = element_line(color = "#3D4852"),
        axis.ticks = element_line(color = "#3D4852"))+
  geom_text(aes(label = y),position = position_stack(vjust = 1.2),colour = "black")+
  theme(legend.position =  c(0.8,0.7))

gg.gap(plot = p1,
       segments = c(30,1200),
       tick_width = c(10,10),
       rel_heights = c(0.25, 0, 0.1),
       ylim = c(0,1220))
