#!/bin/bash

##########################################
##### Basic Unix Commands Exercise #######
##### Jose Barba #########################
##########################################

### 1 - Open a new session in either the Terminal app on your Mac or in you UNIX emulator and sign into the Secure Shell.
### 2 - Copy the exercise’s sample data (homo_sapiens_genome_sequences) into your home directory by copying the data directory from my public directory.
### 3 - Check out the man page for cat.
### 4 - View all files with gene in the name all at once using cat.
### 5 - Repeat this with the protein files.
### 6 - Make two new files, one with all the genes concatenated, one with all the proteins.
### 7 - Make a new file of just the title/name lines from the FASTA gene and protein files -> Hint: use wildcards and note that the title line only has a line break at the end.
### 8 - Make a new directory for all your sequence data files (gene and protein FASTA files) and move the files in there.

#############################
##### Command Reference #####
#############################

### 1 - Open a new session in either the Terminal app on your Mac or a terminal on your UNIX/UNIX-like OS and sign into the Secure Shell:
ssh [username]@erdos.dsm.fordham.edu

### 2 - Copy the exercise’s sample data (homo_sapiens_genome_sequences) into your home directory by copying the data directory from my public directory:
# change to home directory
cd ~
# copy sample data directory and change to it:
cp -r /u/erdos/jbarba/public/homo_sapiens_genome_sequences .
cd homo_sapiens_genome_sequences

### 3 - Check out the man page for cat:
man cat
#prees q to quit

### 4 - View all files with gene in the name all at once using cat:
cat *gene*

### 5 - Repeat this with the protein files
cat *protein*

### 6 - Make two new files, one with all the genes concatenated, one with all the proteins:
cat *gene* > all_genes.fasta
cat *protein* > all_proteins.fasta

### 7 - Make a new file of just the title/name lines from the FASTA gene and protein files -> Hint: use wildcards and note that the title line only has a line break at the end:
grep "^>" *gene.fasta > gene_seq_names.txt
grep "^>" *protein.fasta > protein_seq_names.txt

### 8 - Make a new directory for all your sequence data files (gene and protein FASTA files) and move the files in there:
mkdir all_fasta_files
cp *.fasta all_fasta_files/
