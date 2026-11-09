#!/bin/bash

###################################################################################
##### Genome Mapping and Variant Calling - BWA, SAMtools, Picard, and BCFtool #####
##### Jose Barba ##################################################################
###################################################################################

### connect to erdos (replace erdos_username with your username)
ssh erdos_username@erdos.dsm.fordham.edu

### copy the tutorial directory to the home directory
cp -r /u/erdos/jbarba/public/genome_mapping_and_variant_calling ~

### activate the bioinformatics conda environment
conda activate bioinformatics

### check if java-jdk is installed (a line starting with java-jdk means it is installed)
conda list java-jdk

### remove java-jdk (only if it is installed)
conda remove java-jdk

### install mapping and variant calling tools
conda install -c conda-forge -c bioconda bwa "samtools>=1.21" "bcftools>=1.21" "htslib>=1.21" "picard>=3.0" "openjdk>=17"

### reinstall java to restore files removed with java-jdk
conda install -c conda-forge openjdk --force-reinstall

### change to the genome_mapping_and_variant_calling directory
cd ~/genome_mapping_and_variant_calling/

### decompress the reference genome (required for samtools faidx and picard)
gunzip canFam3.1.MT.fa.gz

#########################################
##### part 1: prepare the reference #####
#########################################

### create a BWA index file
bwa index canFam3.1.MT.fa

### create a SAMTOOLS index file
samtools faidx canFam3.1.MT.fa

### create a sequence dictionary with Picard
picard CreateSequenceDictionary -R canFam3.1.MT.fa -O canFam3.1.MT.dict

### get the name of the mitochondrial reference sequence (used later with samtools tview)
MT_NAME=$(cut -f1 canFam3.1.MT.fa.fai)
echo $MT_NAME

### create a sequence dictionary with picard
picard CreateSequenceDictionary -R canFam3.1.MT.fa -O canFam3.1.MT.dict

#################################
##### part 2: map the reads #####
#################################

### map the paired-end reads to the reference, add a read group, and sort by coordinate
bwa mem -t 4 -R '@RG\tID:coyote\tSM:coyote\tPL:ILLUMINA' \
  canFam3.1.MT.fa coyote.R1.MT.fq.gz coyote.R2.MT.fq.gz \
  | samtools sort -o coyote.MT.sorted.bam -

### index the sorted BAM (required by samtools tview and other tools)
samtools index coyote.MT.sorted.bam

### mark duplicate reads with Picard
picard MarkDuplicates -I coyote.MT.sorted.bam -O coyote.MT.dedup.bam -M coyote.MT.dup_metrics.txt

### index the deduplicated BAM
samtools index coyote.MT.dedup.bam

#####################################
##### part 3: check the mapping #####
#####################################

### mapping statistics (check the percentage of mapped and properly paired reads)
samtools flagstat coyote.MT.sorted.bam

### mapping statistics after marking duplicates (check the "duplicates" line)
samtools flagstat coyote.MT.dedup.bam

### calculate the mean sequencing depth across the mitochondrial genome
samtools depth -a coyote.MT.dedup.bam | awk '{sum += $3} END {print "mean depth:", sum/NR}'

### visualize the alignments (? for help, g to go to a position such as NC_002008.4:1000, q to quit)
samtools tview coyote.MT.dedup.bam canFam3.1.MT.fa

###########################################################################
##### part 4: build a coyote consensus directly from the mapped reads #####
###########################################################################

### build a coyote mitochondrial consensus directly from the mapped reads
### positions without read coverage are written as N instead of copying the dog reference
samtools consensus -a -o coyote.MT.samtools_consensus.fa coyote.MT.dedup.bam

### rename the sequence header to identify the coyote consensus
sed -i '1s/.*/>coyote_MT_samtools_consensus/' coyote.MT.samtools_consensus.fa

### count the number of N in the consensus (positions with no coverage or with reads that disagree)
grep -v ">" coyote.MT.samtools_consensus.fa | tr -cd 'Nn' | wc -c

### show the position of each N along the consensus (counting from 0)
grep -v ">" coyote.MT.samtools_consensus.fa | tr -d '\n' | grep -ob 'N'

### check the length of the coyote consensus
grep -v ">" coyote.MT.samtools_consensus.fa | tr -d '\n' | wc -c

### check the length of the dog mitochondrial reference genome (canFam3.1.MT)
grep -v ">" canFam3.1.MT.fa | tr -d '\n' | wc -c

###############################################
##### part 5: call variants with bcftools #####
###############################################

### the reads are from a coyote and the reference is the dog mitochondrial genome,
### so the variants found here are differences between the coyote and dog mitogenomes

### call variants (high depth limits for mitochondrial coverage, haploid, variant sites only)
bcftools mpileup -f canFam3.1.MT.fa --max-depth 10000 --max-idepth 10000 -a FORMAT/AD,FORMAT/DP coyote.MT.dedup.bam \
  | bcftools call -m -v --ploidy 1 -Oz -o coyote.MT.vcf.gz

### index the vcf file
bcftools index -f coyote.MT.vcf.gz

### look at the end of the vcf header and the column names
bcftools view -h coyote.MT.vcf.gz | tail -5

### look at the first variants
bcftools view -H coyote.MT.vcf.gz | head

### count the number of variants
bcftools view -H coyote.MT.vcf.gz | wc -l

### summary statistics:
bcftools stats coyote.MT.vcf.gz > coyote.MT.vcf.stats.txt

### numbers of SNPs and indels
grep "^SN" coyote.MT.vcf.stats.txt

### transitions (ts), transversions (tv) and ts/tv ratio
grep "^TSTV" coyote.MT.vcf.stats.txt

#####################################################
##### part 6: filter and summarize the variants #####
#####################################################

### keep only variants with quality of at least 30 and a depth of at least 10 reads
bcftools filter -i 'QUAL>=30 && INFO/DP>=10' -Oz -o coyote.MT.filtered.vcf.gz coyote.MT.vcf.gz

### index the filtered VCF file
bcftools index coyote.MT.filtered.vcf.gz

### count the variants that passed the filter
bcftools view -H coyote.MT.filtered.vcf.gz | wc -l

### count SNPs and indels separately
bcftools view -H -v snps coyote.MT.filtered.vcf.gz | wc -l
bcftools view -H -v indels coyote.MT.filtered.vcf.gz | wc -l

### create a simple table with position, reference allele, alternative allele, quality and depth
bcftools query -f '%CHROM\t%POS\t%REF\t%ALT\t%QUAL\t%INFO/DP\n' coyote.MT.filtered.vcf.gz > coyote.MT.variants.tsv
head coyote.MT.variants.tsv

### view the first variant in tview (to change variant, replace 70 with a position from coyote.MT.variants.tsv)
samtools tview -p ${MT_NAME}:70 coyote.MT.dedup.bam canFam3.1.MT.fa

#################################################################################
##### part 7: build a coyote consensus MT gnemoe from the filtered variants #####
#################################################################################

### apply the filtered variants to the dog reference to obtain a coyote mitochondrial sequence
### note: positions without read coverage keep the dog base (compare with the samtools consensus)
bcftools consensus -f canFam3.1.MT.fa coyote.MT.filtered.vcf.gz > coyote.MT.bcftools_consensus.fa

### rename the sequence header to identify the coyote consensus
sed -i '1s/.*/>coyote_MT_bcftools_consensus/' coyote.MT.bcftools_consensus.fa

### check the length of the consensus sequence
grep -v ">" coyote.MT.bcftools_consensus.fa | tr -d '\n' | wc -c

############################################################################
##### part 8: summarize the genome mapping and variant calling results #####
############################################################################

### the following commands summarize the main results of this tutorial

### 1. percentage of mapped reads ("mapped" line) and number of duplicates ("duplicates" line)
samtools flagstat coyote.MT.sorted.bam
samtools flagstat coyote.MT.dedup.bam

### 2. mean sequencing depth (much higher than 30x because cells carry many mitochondrial genomes)
samtools depth -a coyote.MT.dedup.bam | awk '{sum += $3} END {print "mean depth:", sum/NR}'

### 3. length of the coyote consensus and the dog reference (they differ because of indels)
grep -v ">" coyote.MT.samtools_consensus.fa | tr -d '\n' | wc -c
grep -v ">" canFam3.1.MT.fa | tr -d '\n' | wc -c

### 4. number of filtered variants, SNPs, indels, transitions (ts), transversions (tv) and ts/tv ratio
bcftools view -H coyote.MT.filtered.vcf.gz | wc -l
bcftools view -H -v snps coyote.MT.filtered.vcf.gz | wc -l
bcftools view -H -v indels coyote.MT.filtered.vcf.gz | wc -l
bcftools stats coyote.MT.filtered.vcf.gz | grep "^TSTV"

### 5a. variant table (name, position, dog base, coyote base, quality, depth)
head coyote.MT.variants.tsv

### 5b. show only the indels (rows where the dog and coyote alleles differ in length)
awk 'length($3) != length($4)' coyote.MT.variants.tsv

### 5c. view the alignments (arrows to move, g then NC_002008.4:106 to go to the second SNP, q to quit)
samtools tview coyote.MT.dedup.bam canFam3.1.MT.fa

### 6. number of N in each consensus (samtools writes N for uncertain positions, bcftools keeps dog bases)
grep -v ">" coyote.MT.samtools_consensus.fa | tr -cd 'Nn' | wc -c
grep -v ">" coyote.MT.bcftools_consensus.fa | tr -cd 'Nn' | wc -c
