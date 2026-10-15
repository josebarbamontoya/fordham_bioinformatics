#!/bin/bash

######################################################################
##### Retrieving Genomic Data from NCBI Using Command-Line Tools #####
##### Jose Barba #####################################################
######################################################################

### connect to the remote server erdos using ssh:
ssh erdos_username@erdos.dsm.fordham.edu

##########################################################
##### Install Entrez Direct and fetch gene sequences #####
##########################################################

### change to the home directory
cd ~

### download entrez direct installer
wget https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/install-edirect.sh

### run the installer
sh install-edirect.sh

### when prompted, enter `y` to add entrez direct to path in .bashrc

### if not prompted, manually add the directory to path:
#echo 'export PATH="$HOME/edirect:$PATH"' >> ~/.bashrc

### Apply the path changes
source ~/.bashrc

### check whether the tools were installed properly
efetch -help
esearch -help

### fetch 16S rRNA sequences from Genus Drosophila records, excluding complete mitochondrial genomes and other genes
esearch -db nuccore -query \
  '"Drosophila"[Organism] AND ("16S ribosomal RNA"[Title] OR rrnL[Gene] OR 16S[Gene]) NOT ("12S"[Title] OR COI[Title] OR COIII[Title] OR cytb[Title] OR "complete genome"[Title] OR "whole genome"[Title] OR NADH[Title])' \
  | efetch -format fasta > Drosophila_16S_rRNA.fasta

### count the number of sequences downloaded
grep -c '^>' Drosophila_16S_rRNA.fasta

### check the downloaded sequences
cat Drosophila_16S_rRNA.fasta

########################################################################################
##### Install the NCBI Datasets command-line tools and retrieve a reference genome #####
########################################################################################

### change to the home directory
cd ~

### create a directory for the NCBI Datasets tools
mkdir ncbi_datasets

### change to the `ncbi_datasets` directory
cd ncbi_datasets

### download the command-line tools
wget https://ftp.ncbi.nlm.nih.gov/pub/datasets/command-line/v2/linux-amd64/datasets
wget https://ftp.ncbi.nlm.nih.gov/pub/datasets/command-line/v2/linux-amd64/dataformat

### make both executables
chmod +x datasets dataformat

### add the directory to path
echo 'export PATH="$HOME/ncbi_datasets:$PATH"' >> ~/.bashrc

### apply the path changes
source ~/.bashrc

### verify installation
datasets --version
dataformat version

### change to the home directory
cd ~

### set the accession number of the Drosophila melanogaster reference genome
accession=GCF_000001215.4

### download the reference genome and associated annotation files
datasets download genome accession "$accession" \
  --include gff3,rna,cds,protein,genome,seq-report \
  --filename "${accession}.zip"

### extract the archive into a new directory
unzip GCF_000001215.4.zip -d GCF_000001215.4

### see te rosophila melanogaster reference  genome data files
ls -lh GCF_000001215.4/ncbi_dataset/data/GCF_000001215.4/

### count the number of RNA sequences
grep -c '^>' GCF_000001215.4/ncbi_dataset/data/GCF_000001215.4/rna.fna

### count the number coding DNA seqences
grep -c '^>' GCF_000001215.4/ncbi_dataset/data/GCF_000001215.4/cds_from_genomic.fna

### count the number coding of protein seqences
grep -c '^>' GCF_000001215.4/ncbi_dataset/data/GCF_000001215.4/protein.faa

### see the genome annotation file
less GCF_000001215.4/ncbi_dataset/data/GCF_000001215.4/genomic.gff
### type q to exit

##########################################################################
##### Install the NCBI SRA Toolkit and retrieve WGS sequencing reads #####
##########################################################################

### change to the home directory
cd ~

### download the SRA Toolkit
wget https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/3.4.1/sratoolkit.3.4.1-ubuntu64.tar.gz

### extract the archive
tar -xzf sratoolkit.3.4.1-ubuntu64.tar.gz

### add the toolkit bin directory to path in .bashrc
echo 'export PATH="$PATH:$HOME/sratoolkit.3.4.1-ubuntu64/bin"' >> ~/.bashrc

### apply the path changes
source ~/.bashrc

### check whether the toolkit is available
fasterq-dump --version

### create a new directory to download the raw reads
mkdir Drosophila_m_raw_reads

### change to the `Drosophila_m_raw_reads` directory
cd Drosophila_m_raw_reads

### fetch FASTQ reads for Drosophila melanogaster
fasterq-dump SRR29479670

### count the number of reads in the FASTQ files
wc -l < SRR29479670_1.fastq | awk '{print $1/4}'
wc -l < SRR29479670_2.fastq | awk '{print $1/4}'

### see the content of a FASTQ file
less SRR29479670_1.fastq
### type q to exit

### compress the FASTQ files to reduce disk space usage
gzip SRR29479670_1.fastq &
gzip SRR29479670_2.fastq &

### see the contents of a compressed FASTQ file
gzip -dc SRR29479670_2.fastq.gz | less
### type q to exit

### count the number of reads in the compressed FASTQ files
gzip -dc SRR29479670_1.fastq.gz | wc -l | awk '{print $1/4}'
gzip -dc SRR29479670_2.fastq.gz | wc -l | awk '{print $1/4}'

### optional: open the interactive Toolkit configuration menu
vdb-config -i
### type x to exit
