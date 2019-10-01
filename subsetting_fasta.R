## to subset a fasta file using the ID or names of sequences

library(plyr)
library(seqinr)
library(purrr)
library(seqRFLP)

setwd("D:/") # directory with fasta and .txt or .csv with the ID or names of the sequence to subset

x <- seqinr::read.fasta(file = "subsetHK.fasta", seqtype = "AA", as.string = TRUE) #fasta file with large dataset seqtype = "AA" or "DNA"
y <- read.csv("HK2.csv", col.names = "ID") #ID of sequence to subset for small dataset


subset_fasta_from_list <- function(x,y){
  list.from.fasta <- purrr::map(x,1) ## convert complex list derived from fasta file to simple list with ID and sequences
  df.fasta <- plyr::ldply (list.from.fasta, data.frame) # convert list to data frame
  colnames(df.fasta) <- c("ID", "secuencia") #change name of the columns
  subset.fasta <- filter(df.fasta, df.fasta$ID %in% y$ID) #filter the sequences from the ID text/csv in the data frame
  return(subset.fasta)
  
}

df <- subset_fasta_from_list(x,y) # x = fasta file, y = data.frame with the ID or names of sequences. 

##save Data frame to fasta file

out <- seqRFLP::dataframe2fas(df,"subsetHK2.fasta")
