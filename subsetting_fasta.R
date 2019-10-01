library(plyr)
library(seqinr)
library(purrr)
library(seqRFLP)

setwd("D:/")

x <- seqinr::read.fasta(file = "subsetHK.fasta", seqtype = "AA", as.string = TRUE) #fasta file with large dataset seqtype = "AA" or "DNA"
y <- read.csv("HK2.csv", col.names = "ID") #ID of sequence to subset for small dataset


subset_fasta_from_list <- function(x,y){
  list.from.fasta <- purrr::map(x,1) ## complex list from fasta file to simple list with ID and sequence
  df.fasta <- plyr::ldply (list.from.fasta, data.frame) # list to data frame
  colnames(df.fasta) <- c("ID", "secuencia") #name the columns
  subset.fasta <- filter(df.fasta, df.fasta$ID %in% y$ID) #filter the sequences I want
  return(subset.fasta)
  
}

df <- subset_fasta_from_list(x,y)

##save Data frame to fasta file

out <- seqRFLP::dataframe2fas(df,"subsetHK2.fasta")
