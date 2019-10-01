## Graph based on the plot from GBtools library. Adapted for the ATLAS2 ouptup files.
# Files needed: (sample_name).coverage.stats.txt located in directory = (sample_name)/binning/coverage  and cluster_attribution.tsv
# located in directory = (sample_name)/binning/DASTool
# melody C.O.


library(ggplot2)
library(dplyr)

setwd("D:/") # Directory where the files are located

cs <- read.table("samplename_coverage_stats.txt", header = TRUE) 
bin <- read.table("cluster_attribution.tsv", col.names = c("ID","bin")) 
names(cs) #confirm the colums have their names
names(bin) #confirm the colums have their names

## function that filter for contig or scafold > 1000 bp, subset  for ID, Avg_fold, Length, 
#and Ref_GC, and add colum of bin agrupation.

subset_cove_stats <- function(x,y) {
  resultado <- x %>%
    filter(Length > 1000) %>%
    select(ID, Avg_fold, Length, Ref_GC)
  resultado2 <- merge(resultado,y,by="ID", all.x = TRUE)
  return(resultado2)
  
}

df <- subset_cove_stats(cs,bin) 

plot.cove.stat <- ggplot(df, aes(x=Ref_GC, y=Avg_fold, size=Length, color=bin)) + 
  geom_point(alpha=0.5) + ## alpha 0.5 will make the points more transparent
  scale_y_log10(breaks = c(1, 100, 10000)) + #change values in breaks of y labels
  scale_x_continuous(breaks = seq(0.2, 0.9, by = 0.1)) + #change values of X labels
  labs(
    x = "GC content",
    y = "Coverage",
    color = "BIN") +
  scale_size_area(name = "Scaffold length", max_size = 15)

plot.cove.stat +  theme(               #play with theme() to change other aesthetic properties of the plot
  axis.title.x = element_text(size=18),
  axis.title.y = element_text(size=18),
  legend.title = element_text(size = 16),
  axis.text.x = element_text(size=16),
  axis.text.y = element_text(size=16),
  legend.text = element_text(size = 16)) 

ggsave("plot.png", height = 8, width = 10, units = "in", dpi = 300, device='png') ## save plot



