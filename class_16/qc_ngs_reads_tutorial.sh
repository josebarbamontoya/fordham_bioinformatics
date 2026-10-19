#!/bin/bash

###################################################
##### Quality Control of NGS Reads with fastp #####
##### Jose Barba ##################################
###################################################

### connect to the remote server erdos using ssh:
ssh erdos_username@erdos.dsm.fordham.edu

######################################################
##### Create Conda Environment and Install fastp #####
######################################################

### create conda python environment
conda --version
which conda
conda create -n bioinformatics python=3.14.7

### activate tue python environment (required everytime I want to use python in erdos)
conda activate bioinformatics

### install fastp 
conda install bioconda::fastp

### deactivate the conda environment
conda deactivate

####################################
##### Retrieve NGS Reads Reads #####
####################################

### change to the home directory
cd ~

### create a new directory to download the raw reads
mkdir qc_ngs_reads

### change to the `qc_ngs_reads` directory
cd qc_ngs_reads

### fetch FASTQ reads for Drosophila melanogaster
fasterq-dump SRR40747365

### compress the FASTQ files to reduce disk space usage
gzip SRR40747365_1.fastq &
gzip SRR40747365_2.fastq &
wait

### Optional: if you were unable to download the raw reads, copy the sample data directory to the current directory (.)
cp -r /u/erdos/jbarba/public/qc_ngs_reads .

#####################
##### Run fastp #####
#####################

## change to the home directory
cd ~

### activate environment (required everytime I want to use python in erdos)
conda activate bioinformatics

### change to the `qc_ngs_reads` directory
cd qc_ngs_reads

### run fastp
fastp -i SRR40747365_1.fastq.gz -I SRR40747365_2.fastq.gz -o SRR40747365_1_trimmed.fastq.gz -O SRR40747365_2_trimmed.fastq.gz --detect_adapter_for_pe -h paired_fastp_report_SRR40747365.html

### optional: count the number of reads in the compressed FASTQ files
#gzip -dc SRR40747365_1.fastq.gz | wc -l | awk '{print $1/4}'
#gzip -dc SRR40747365_2.fastq.gz | wc -l | awk '{print $1/4}'

### optional: count the number of reads in the compressed FASTQ trimmed files
#gzip -dc SRR40747365_1_trimmed.fastq.gz | wc -l | awk '{print $1/4}'
#gzip -dc SRR40747365_2_trimmed.fastq.gz | wc -l | awk '{print $1/4}'

### deactivate the conda environment
conda deactivate

### log out of erdos
exit

################################################
##### Transfer fastp Report to Your Laptop #####
################################################

### in unix and mac (terminal): transfer the fastp report to your home directory
### NOTE: replace the username and file path with your own
scp username@erdos.dsm.fordham.edu:/u/erdos/students/username/qc_ngs_reads/paired_fastp_report_SRR40747365.html ~/

### explore the results by opening the fastp report in a web browser

### in windows (powershell): transfer the fastp report to your home directory
### NOTE: replace the username and file path with your own
scp username@erdos.dsm.fordham.edu:/u/erdos/students/username/qc_ngs_reads/paired_fastp_report_SRR40747365.html "$HOME"

### explore the results by opening the fastp report in a web browser
