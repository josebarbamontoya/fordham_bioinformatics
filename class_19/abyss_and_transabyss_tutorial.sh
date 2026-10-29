#!/bin/bash

###########################################################################
##### Genome and Transcritome Assembly - ABySS / Trans-ABySS Tutorial #####
##### Jose Barba ##########################################################
###########################################################################

### connect to the remote server erdos using ssh:
### NOTE: REPLACE THE ERDOS_USERNAME WITH YOUR OWN USERNAME
ssh erdos_username@erdos.dsm.fordham.edu

### change to the home directory
cd ~

### copy the sample fastq reads to the current directory (.)
cp -r /u/erdos/jbarba/public/genome_transcriptome_assembly .

################################################################################
##### install abyss and transabyss in the bioinformatics conda environment #####
################################################################################

### if you get a permission denied error, copy the sample fastq reads to the current directory (.) using the following command:
#cp -r /u/erdos/jbarba/genome_transcriptome_assembly .

### if you have not yet created a conda python environment for the bioinformatics class, create one using the following command. Otherwise, proceed to the next step:
#conda create -n bioinformatics python=3.14.7

### activate the bioinformatics conda environment (required everytime I want to use abyss and transabyss in erdos)
conda activate bioinformatics

### abyss and transabyss installation
conda install -c bioconda -c conda-forge abyss blat
python -m pip install igraph
git clone https://github.com/bcgsc/transabyss.git ~/transabyss

### confirm abyss installation
ABYSS --version

### confirm transabyss installation
~/transabyss/transabyss --version

############################################################################
##### run abyss and transabyss in the bioinformatics conda environment #####
############################################################################

### change to the genome_assembly_abyss directory
cd genome_transcriptome_assembly

### Streptococcus pneumoniae genome assembly 
abyss-pe j=5 k=75 B=2G v=-v name=streptococcus_wgs_assembly in='SRR41341091_1.fastq_trimmed.gz SRR41341091_2.fastq_trimmed.gz'

### Streptococcus pneumoniae transcriptome assembly
~/transabyss/transabyss --pe DRR1049364_1.fastq_trimmed.gz DRR1049364_2.fastq_trimmed.gz --name streptococcus_rna-seq_assembly --kmer 32 --threads 5 --outdir .

### create summary file for Streptococcus pneumoniae transcriptome assembly
abyss-fac streptococcus_rna-seq_assembly-3.fa streptococcus_rna-seq_assembly-6.fa streptococcus_rna-seq_assembly-final.fa > streptococcus_rna-seq_assembly-stats.tab

### Corynebacterium diphtheriae genome assembly 
abyss-pe j=5 k=75 B=2G v=-v name=corynebacterium_wgs_assembly in='SRR41341089_1.fastq_trimmed.gz SRR41341089_2.fastq_trimmed.gz'

### Corynebacterium diphtheriae transcriptome assembly
~/transabyss/transabyss --pe SRR13530935_1.fastq_trimmed.gz SRR13530935_2.fastq_trimmed.gz --name corynebacterium_rna-seq_assembly --kmer 32 --threads 5 --outdir .

### create summary file for Corynebacterium diphtheriae transcriptome assembly
abyss-fac corynebacterium_rna-seq_assembly-3.fa corynebacterium_rna-seq_assembly-6.fa corynebacterium_rna-seq_assembly-final.fa > corynebacterium_rna-seq_assembly-stats.tab

### deactivate the conda environment
conda deactivate

########################################
##### check the assambly summaries #####
########################################

### view the Streptococcus pneumoniae transcriptome wgs assembly summary (unitigs, contigs, scaffolds, final assembly)
cat streptococcus_wgs_assembly-stats.md

### view the Streptococcus pneumoniae transcriptome rna-seq summary (unitigs, contigs, final assembly)
cat streptococcus_rna-seq_assembly-stats.tab

### view the Corynebacterium diphtheriae wgs assembly summary (unitigs, contigs, scaffolds, final assembly)
cat corynebacterium_wgs_assembly-stats.md

### view the Corynebacterium diphtheriae rna-seq assembly summary (unitigs, contigs, final assembly)
cat corynebacterium_rna-seq_assembly-stats.tab

### create a text file containing all assembly summaries
cat streptococcus_wgs_assembly-stats.md streptococcus_rna-seq_assembly-stats.tab corynebacterium_wgs_assembly-stats.md corynebacterium_rna-seq_assembly-stats.tab > all_assembly_summaries.txt
