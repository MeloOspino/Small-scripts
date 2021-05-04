#!/bin/bash
# Input variable
database_dir=$1  ## PATH where the .faa.gz files are present

## updating Refseq database
cd $1
zcat *.faa.gz >Refseq.fa ## Decompress and concatenate files to standard output
cp Refseq.fa ./Refseq_backup  #backup your refseq copy first
perl ./scripts/reformatRefseq.pl Refseq.fa > Refseq.updated.fa
mv Refseq.updated.fa Refseq.fa
perl ./scripts/cleanDatabase.pl Refseq.fa > list_to_remove.txt
perl ./scripts/removeFromFasta.pl list_to_remove.txt Refseq.fa > Refseq.fixed.fa
rm list_to_remove.txt
rm Refseq.fa
mv Refseq.fixed.fa Refseq.fa
esl-sfetch --index Refseq.fa
##"Downloading and indexing gi number to taxid mappings.\n"
wget ftp://ftp.ncbi.nih.gov/pub/taxonomy/accession2taxid/prot.accession2taxid.gz
gunzip prot.accession2taxid.gz
awk '{ print $2,$3 }' prot.accession2taxid > gi_taxid_prot.dmp
##"Downloading and indexing taxonomy info.\n"
grep 'scientific name' names.dmp > trimmed.names.dmp
python ./scripts/make_taxonomy_pickle.py
