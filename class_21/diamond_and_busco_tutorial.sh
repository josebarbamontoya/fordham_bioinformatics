#!/bin/bash

################################################################################
##### Functional Genome Annotation - DIAMOND and BUSCO Tutorial ################
##### Jose Barba ###############################################################
################################################################################

### connect to the remote server erdos using ssh (replace erdos_username with your own username)
ssh erdos_username@erdos.dsm.fordham.edu

### change to the home directory
cd ~

### copy the completed augustus tutorial directory to the home directory as functional_genome_annotation_diamond
cp -r /u/erdos/jbarba/public/structural_genome_annotation_augustus_completed ~/functional_genome_annotation_diamond

### activate the bioinformatics conda environment (required every time you use these tools on erdos)
conda activate bioinformatics

### install the tools for functional annotation (only if they are missing)
conda install -c bioconda -c conda-forge gffread diamond

################################################################################
##### part a: Drosophila melanogaster ##########################################
################################################################################

### change to the drosophila_melanogaster directory
cd ~/functional_genome_annotation_diamond/drosophila_melanogaster

##### step 1: extract protein sequences #####

### extract the proteins predicted by augustus
gffread chr4_augustus.gff3 -g chr4.fa -y chr4_augustus_proteins.faa

### extract the ncbi reference proteins for chromosome 4 (all isoforms)
gffread ncbi_chr4.gff3 -g chr4.fa -y ncbi_chr4_proteins.faa

### remove the stop codon symbol at the end of each protein sequence
sed -i '/^>/!s/[.*]$//' chr4_augustus_proteins.faa ncbi_chr4_proteins.faa

### count the proteins in each file
echo "Augustus proteins: $(grep -c '>' chr4_augustus_proteins.faa)"
echo "NCBI proteins (all isoforms): $(grep -c '>' ncbi_chr4_proteins.faa)"

##### step 2: functional annotation with diamond #####

### search the augustus proteins against swiss-prot (best match per protein, 4 cpus)
diamond blastp \
  -q chr4_augustus_proteins.faa \
  -d /u/erdos/jbarba/public/swissprot \
  -o chr4_swissprot_hits.tsv \
  --max-target-seqs 1 \
  --evalue 1e-5 \
  --threads 4 \
  --outfmt 6 qseqid sseqid pident length evalue bitscore stitle

### output columns:
###   qseqid   augustus protein id
###   sseqid   swiss-prot protein id
###   pident   percent identity
###   length   alignment length
###   evalue   expected number of chance matches (smaller is better)
###   bitscore alignment score (larger is better)
###   stitle   description of the swiss-prot protein (name, OS = species, GN = gene name)

### show each augustus protein with its percent identity, e-value and best match
cut -f1,3,5,7 chr4_swissprot_hits.tsv | column -t -s $'\t'

### count the augustus proteins that received a functional annotation
echo "Annotated proteins: $(cut -f1 chr4_swissprot_hits.tsv | sort -u | wc -l)"

### show only the gene names (GN=) of the best matches
grep -o 'GN=[^ ]*' chr4_swissprot_hits.tsv | sort | uniq -c

##### step 3: completeness with busco #####

### busco searches for genes expected once in nearly all species of a lineage.
### here we use diptera_odb10 (flies). the lineage dataset is already downloaded
### in the public directory, so busco runs offline.
### note: busco is designed for whole genomes. chromosome 4 contains only a few
### busco genes, so the completeness percentage will be very low. what matters
### here is the comparison between augustus and ncbi proteins.

### run busco on the augustus proteins
/u/erdos/jbarba/public/bin/busco -i chr4_augustus_proteins.faa -m proteins -l diptera_odb10 -c 4 \
  -o busco_augustus_chr4 --offline --download_path /u/erdos/jbarba/public/busco_downloads -f

### run busco on the ncbi proteins
/u/erdos/jbarba/public/bin/busco -i ncbi_chr4_proteins.faa -m proteins -l diptera_odb10 -c 4 \
  -o busco_ncbi_chr4 --offline --download_path /u/erdos/jbarba/public/busco_downloads -f

### compare the two busco summaries
### C complete (S single-copy, D duplicated), F fragmented, M missing, n busco genes searched
grep "C:" busco_augustus_chr4/short_summary*.txt busco_ncbi_chr4/short_summary*.txt

### show the full summary for augustus
cat busco_augustus_chr4/short_summary*.txt

################################################################################
##### part b: Drosophila simulans ##############################################
################################################################################

### change to the drosophila_simulans directory
cd ~/functional_genome_annotation_diamond/drosophila_simulans

##### step 1: extract protein sequences #####

### extract the proteins predicted by augustus
gffread chr4_augustus.gff3 -g chr4.fa -y chr4_augustus_proteins.faa

### extract the ncbi reference proteins for chromosome 4 (all isoforms)
gffread ncbi_chr4.gff3 -g chr4.fa -y ncbi_chr4_proteins.faa

### remove the stop codon symbol at the end of each protein sequence
sed -i '/^>/!s/[.*]$//' chr4_augustus_proteins.faa ncbi_chr4_proteins.faa

### count the proteins in each file
echo "Augustus proteins: $(grep -c '>' chr4_augustus_proteins.faa)"
echo "NCBI proteins (all isoforms): $(grep -c '>' ncbi_chr4_proteins.faa)"

##### step 2: functional annotation with diamond #####

### search the augustus proteins against swiss-prot (best match per protein, 4 cpus)
diamond blastp \
  -q chr4_augustus_proteins.faa \
  -d /u/erdos/jbarba/public/swissprot \
  -o chr4_swissprot_hits.tsv \
  --max-target-seqs 1 \
  --evalue 1e-5 \
  --threads 4 \
  --outfmt 6 qseqid sseqid pident length evalue bitscore stitle

### show each augustus protein with its percent identity, e-value and best match
cut -f1,3,5,7 chr4_swissprot_hits.tsv | column -t -s $'\t'

### count the augustus proteins that received a functional annotation
echo "Annotated proteins: $(cut -f1 chr4_swissprot_hits.tsv | sort -u | wc -l)"

### show only the gene names (GN=) of the best matches
grep -o 'GN=[^ ]*' chr4_swissprot_hits.tsv | sort | uniq -c

##### step 3: completeness with busco #####

### run busco on the augustus proteins
/u/erdos/jbarba/public/bin/busco -i chr4_augustus_proteins.faa -m proteins -l diptera_odb10 -c 4 \
  -o busco_augustus_chr4 --offline --download_path /u/erdos/jbarba/public/busco_downloads -f

### run busco on the ncbi proteins
/u/erdos/jbarba/public/bin/busco -i ncbi_chr4_proteins.faa -m proteins -l diptera_odb10 -c 4 \
  -o busco_ncbi_chr4 --offline --download_path /u/erdos/jbarba/public/busco_downloads -f

### compare the two busco summaries
grep "C:" busco_augustus_chr4/short_summary*.txt busco_ncbi_chr4/short_summary*.txt

################################################################################
##### part c: compare Drosophila melanogaster and Drosophila simulans ##########
################################################################################

### change to the main tutorial directory, which contains both species directories
cd ~/functional_genome_annotation_diamond

### compare the number of augustus and ncbi proteins
echo "Drosophila melanogaster - augustus proteins: $(grep -c '>' drosophila_melanogaster/chr4_augustus_proteins.faa), ncbi proteins: $(grep -c '>' drosophila_melanogaster/ncbi_chr4_proteins.faa)"
echo "Drosophila simulans     - augustus proteins: $(grep -c '>' drosophila_simulans/chr4_augustus_proteins.faa), ncbi proteins: $(grep -c '>' drosophila_simulans/ncbi_chr4_proteins.faa)"

### compare the number of augustus proteins with a swiss-prot match
echo "Drosophila melanogaster - augustus proteins with a swiss-prot match: $(cut -f1 drosophila_melanogaster/chr4_swissprot_hits.tsv | sort -u | wc -l)"
echo "Drosophila simulans     - augustus proteins with a swiss-prot match: $(cut -f1 drosophila_simulans/chr4_swissprot_hits.tsv | sort -u | wc -l)"

### extract the gene names (GN=) of the best swiss-prot matches in each species
grep -o 'GN=[^ ]*' drosophila_melanogaster/chr4_swissprot_hits.tsv | sort -u > dmel_gene_names.txt
grep -o 'GN=[^ ]*' drosophila_simulans/chr4_swissprot_hits.tsv | sort -u > dsim_gene_names.txt

### list the gene names found in each species
echo -e "gene names found in Drosophila melanogaster:\n$(cat dmel_gene_names.txt)"
echo -e "gene names found in Drosophila simulans:\n$(cat dsim_gene_names.txt)"

### list the gene names found in both species and in only one species
echo -e "gene names found in both species:\n$(comm -12 dmel_gene_names.txt dsim_gene_names.txt)"
echo -e "gene names found only in Drosophila melanogaster:\n$(comm -23 dmel_gene_names.txt dsim_gene_names.txt)"
echo -e "gene names found only in Drosophila simulans:\n$(comm -13 dmel_gene_names.txt dsim_gene_names.txt)"

### compare the four busco summaries (augustus and ncbi for each species)
grep "C:" drosophila_*/busco_*_chr4/short_summary*.txt
