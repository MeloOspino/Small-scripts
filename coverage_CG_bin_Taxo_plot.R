## Graph based on the plot from GBtools library. Adapted for the ATLAS2 output files.
# melody C.O.
#NOTE = ERASE the # hashtag in the files, R does not like it.


library(ggplot2)
library(dplyr)

setwd("D:/") # Directory where the files are located

##upload the files needed for the plot from the ATLAS ouput. 
#[SAMPLE_NAME]_coverage_stats.txt located in directory = [SAMPLE_NAME]/binning/coverage
#cluster_atribution.tsv located in directory = [SAMPLE_NAME]/binning/DASTool
#completeness.tsv located in directory = [SAMPLE_NAME]/binning/DASTool/checkm

cs <- read.table("[SAMPLE_NAME]_coverage_stats.txt", header = TRUE)  
bin <- read.table("cluster_attribution.tsv", col.names = c("ID","bin")) 
taxo <- read.table("completeness.tsv", header = TRUE, fill = TRUE) ## fill = TRUE when there is 0 or no element in a column cell

## function that prepares the data for the plot

#Function that filter contig or scaffold > 1000 bp, subset  for ID, Avg_fold, Length, and Ref_GC. Also, add a column for bin groups.

subset_cove_stats <- function(x,y) {
  resultado <- x %>%
    filter(Length > 1000) %>%
    select(ID, Avg_fold, Length, Ref_GC)
  resultado2 <- merge(resultado,y,by="ID", all.x = TRUE)
  return(resultado2)
  
}

## Function that organize the data for the lineage annotation

lineage_by_bin <- function(x,y,z){
  taxo2 <- z %>% ## subset taxo data.frame with only the BIN and lineage and rename column
    select(Bin, Id) %>%
    rename(bin = Bin, lineage = Id)
  dfcsbin <- subset_cove_stats(x,y) ## data frame with coverage and CS
  df2 <- dfcsbin %>%
    left_join(taxo2, by = "bin") ## join both data.frame by bin and add colum of lineage
  df_taxo <- df2 %>%
    na.omit() %>% ## omit NA's
    group_by(bin) %>% ##set one contig/scaffold representative from each bin and lineage
    slice(1)
  return(df_taxo)
  
}

## make the data for the plot

a <- subset_cove_stats(cs,bin) 
b <- lineage_by_bin(cs,bin,taxo)


## plot

plot.cove.stat <- ggplot(a, aes(x=Ref_GC, y=Avg_fold)) + 
  geom_point(aes(color=bin, size = Length),alpha=0.5) + ## alpha 0.5 will make the points more transparent
  scale_y_log10(breaks = c(1, 100, 10000)) + #change values in breaks of y labels
  scale_x_continuous(breaks = seq(0.2, 0.9, by = 0.1)) + #change values of X labels
  labs(
    x = "GC content",
    y = "Coverage",
    color = "BIN") +
  scale_size_area(name = "Scaffold length", max_size = 15)

buble <- plot.cove.stat +  theme(               #play with theme() to change other aesthetic properties of the plot
  axis.title.x = element_text(size=18),
  axis.title.y = element_text(size=18),
  legend.title = element_text(size = 16),
  axis.text.x = element_text(size=16),
  axis.text.y = element_text(size=16),
  legend.text = element_text(size = 16)) 

## change vjust, hjust to play with the location of the lineage annotation.

buble + geom_label(aes(label = lineage), vjust=1.4, hjust=0.5, size=3,colour = "black", fontface = "italic", data = b, alpha = 0.3) 


## save plot

ggsave("plotprueba2.png", height = 8, width = 10, units = "in", dpi = 300, device='png') ## save plot



