#!/bin/bash

###############################################
##### Multiple Sequence Alignment - MAFFT #####
##### Jose Barba ##############################
###############################################

#########################################
##### 16s-rrna gene mafft alignment #####
#########################################

### connect to the remote server erdos using ssh:
ssh erdos_username@erdos.dsm.fordham.edu

### change to the home directory
cd ~

### copy mafft to the current directory (.)
cp -r /u/erdos/jbarba/public/mafft-7.526-linux.tgz .

### uncompress mafft
tar xfvz mafft-7.526-linux.tgz

### create the `mafft_16s_rna_gene_msa` directory 
mkdir mafft_16s_rrna_gene_msa

### change to the `mafft_16s_rna_gene_msa` directory
cd mafft_16s_rrna_gene_msa

### check whether the tools were installed properly
efetch -help
esearch -help

### fetch 16s rrna sequences from Genus Latrodectus (widow spiders) records, excluding complete mitochondrial genomes and other genes
esearch -db nuccore -query \
  '"Latrodectus"[Organism] AND ("16S ribosomal RNA"[Title] OR rrnL[Gene] OR 16S[Gene]) NOT ("12S"[Title] OR COI[Title] OR COIII[Title] OR cytb[Title] OR "complete genome"[Title] OR "whole genome"[Title] OR NADH[Title])' \
  | efetch -format fasta > 16s_rrna_msa.fasta

### count the number of sequences downloaded
grep -c '^>' 16s_rrna_msa.fasta

### check the downloaded sequences
cat 16s_rrna_msa.fasta

### mafft alignment
### NOTE: SUBSTITUTE THE PATH WITH YOUR OWN
/u/erdos/students/username/mafft-linux64/mafft.bat --auto 16s_rrna_msa.fasta > 16s_rrna_msa_mafft.fasta

### ignore jose's path 
###/u/erdos/jbarba/mafft-linux64/mafft.bat --auto 16s_rrna_msa.fasta > 16s_rrna_msa_mafft.fasta

### log out of erdos
exit

####################################################
##### mammal genes mafft msa and concatenation #####
####################################################

### connect to the remote server erdos using ssh:
ssh erdos_username@erdos.dsm.fordham.edu

### change to the home directory
cd ~

### copy the sample data directory to the current directory (.)
cp -r /u/erdos/jbarba/public/mafft_mammal_genes_msa .

### change to the `mafft_mammal_genes_msa` directory
cd mafft_mammal_genes_msa

### mafft alignment loop
### NOTE: SUBSTITUTE THE PATH WITH YOUR OWN
for file in /u/erdos/students/username/mafft_mammal_genes_msa/*.fasta
do
  /u/erdos/students/username/mafft-linux64/mafft.bat --auto $file > $file.mafft.fasta
done

### ignore jose's path and mafft loop
### mafft alignment loop
#for file in /u/erdos/jbarba/mafft_mammal_genes_msa/*.fasta
#do
#  /u/erdos/jbarba/mafft-linux64/mafft.bat --auto $file > $file.mafft.fasta
#done

### create the `gene_concat` director
mkdir gene_concat

### copy the mafft alignments and python msa concatenation script
cp *mafft.fasta gene_concat/
cp msa_concatenation_v2.py gene_concat/

### change to the `gene_concat` directory
cd gene_concat

### activate tue python environment (required everytime I want to use python in erdos)
conda activate bioinformatics

### concatenate the sequence alignments
python msa_concatenation_v2.py

### deactivate the conda environment
conda deactivate

### log out of erdos
exit

##############################################
##### transfer mafft msas to your laptop #####
##############################################

### in unix and mac (terminal): transfer the mafft directories to your home directory
### NOTE: SUBSTITUTE THE USERNAME AND PATH WITH YOUR OWN
scp -r username@erdos.dsm.fordham.edu:/u/erdos/students/username/mafft_16s_rrna_gene_msa ~/
scp -r username@erdos.dsm.fordham.edu:/u/erdos/students/username/mafft_mammal_genes_msa ~/

### explore the results by opening the msas in seaview or aliview

### in windows (powershell): transfer the mafft directories to your home directory
### NOTE: SUBSTITUTE THE USERNAME AND PATH WITH YOUR OWN
scp -r username@erdos.dsm.fordham.edu:/u/erdos/students/username/mafft_16s_rrna_gene_msa "$HOME"
scp -r username@erdos.dsm.fordham.edu:/u/erdos/students/username/mafft_mammal_genes_msa "$HOME"

### explore the results by opening the msas in seaview or aliview
