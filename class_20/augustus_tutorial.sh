#!/bin/bash

############################################################
##### Structural Genome Annotation - AUGUSTUS Tutorial #####
##### Jose Barba ###########################################
############################################################

### connect to the remote server erdos using ssh (replace the erdos_username with your own username)
ssh erdos_username@erdos.dsm.fordham.edu

### change to the home directory
cd ~

### copy the genome_annotation_augustus directory to the current directory (.)
cp -r /u/erdos/jbarba/public/structurtal_genome_annotation_augustus .

### activate the bioinformatics conda environment (required every time you use abyss or augustus on erdos)
conda activate bioinformatics

### install stuff
conda install -c bioconda -c conda-forge augustus seqkit gffread gffcompare 

############################################################################
##### Drosophila melanogaster dot chromosome (chromosome 4) annotation #####
############################################################################

### change to the Drosophila melanogaster genome directory
cd ~/structurtal_genome_annotation_augustus/drosophila_melanogaster

### display basic statistics of the whole genome assembly (number of sequences and length)
seqkit stats GCF_000001215.4_Release_6_plus_ISO1_MT_genomic.fna

### extract chromosome 4 from the genome assembly
seqkit grep -n -r -p "chromosome 4" GCF_000001215.4_Release_6_plus_ISO1_MT_genomic.fna > chr4.fa

### display basic statistics of chromosome 4 (number of sequences and length)
seqkit stats chr4.fa

### chromosome 4 annotation
augustus --species=fly --gff3=on --softmasking=1 chr4.fa > chr4_augustus.gff3 2> augustus_chr4.log

### generate protein and cds sequences for the annotated genes
gffread chr4_augustus.gff3 -g chr4.fa -y chr4_augustus_proteins.faa -x chr4_augustus_cds.fna

##### compare with the ncbi annotation #####

### store the name of the ncbi annotation file in a variable
REF_GFF=genomic.gff

### keep only chromosome 4
CHR4_ID=$(seqkit fx2tab -n -i chr4.fa | cut -f1)
awk -F'\t' -v id=$CHR4_ID '$1==id' $REF_GFF > ncbi_chr4_all.gff

### keep only protein-coding transcripts (augustus predicts only these)
gffread ncbi_chr4_all.gff -C -o ncbi_chr4.gff3

### compare gene counts
echo "Augustus genes: $(awk -F'\t' '$3=="gene"' chr4_augustus.gff3 | wc -l)"
echo "NCBI protein-coding genes: $(awk -F'\t' '$3=="gene" && $9 ~ /gene_biotype=protein_coding/' ncbi_chr4_all.gff | wc -l)"

### compare gene structures (the "unrecognized parented feature" warnings are harmless and can be ignored)
gffcompare -r ncbi_chr4.gff3 -o chr4_vs_ncbi chr4_augustus.gff3
cat chr4_vs_ncbi.stats

### how each augustus transcript matches ncbi (= exact, c contained, j different introns, u no ncbi gene)
tail -n +2 chr4_vs_ncbi.chr4_augustus.gff3.tmap | cut -f3 | sort | uniq -c | sort -nr

########################################################################
##### Drosophila simulans dot chromosome (chromosome 4) annotation #####
########################################################################

### change to the Drosophila simulans genome directory
cd ~/structurtal_genome_annotation_augustus/drosophila_simulans

### display basic statistics of the whole genome assembly (number of sequences and length)
seqkit stats GCF_016746395.2_Prin_Dsim_3.1_genomic.fna

### extract chromosome 4 from the genome assembly
seqkit grep -n -r -p "chromosome 4" GCF_016746395.2_Prin_Dsim_3.1_genomic.fna > chr4.fa

### display basic statistics of chromosome 4 (number of sequences and length)
seqkit stats chr4.fa

### chromosome 4 annotation
augustus --species=fly --gff3=on --softmasking=1 chr4.fa > chr4_augustus.gff3 2> augustus_chr4.log

### generate protein and cds sequences for the annotated genes
gffread chr4_augustus.gff3 -g chr4.fa -y chr4_augustus_proteins.faa -x chr4_augustus_cds.fna

##### compare with the ncbi annotation #####

### store the name of the ncbi annotation file in a variable
REF_GFF=genomic.gff

### keep only chromosome 4
CHR4_ID=$(seqkit fx2tab -n -i chr4.fa | cut -f1)
awk -F'\t' -v id=$CHR4_ID '$1==id' $REF_GFF > ncbi_chr4_all.gff

### keep only protein-coding transcripts (augustus predicts only these)
gffread ncbi_chr4_all.gff -C -o ncbi_chr4.gff3

### compare gene counts
echo "Augustus genes: $(awk -F'\t' '$3=="gene"' chr4_augustus.gff3 | wc -l)"
echo "NCBI protein-coding genes: $(awk -F'\t' '$3=="gene" && $9 ~ /gene_biotype=protein_coding/' ncbi_chr4_all.gff | wc -l)"

### compare gene structures (the "unrecognized parented feature" warnings are harmless and can be ignored)
gffcompare -r ncbi_chr4.gff3 -o chr4_vs_ncbi chr4_augustus.gff3
cat chr4_vs_ncbi.stats

### how each augustus transcript matches ncbi (= exact, c contained, j different introns, u no ncbi gene)
tail -n +2 chr4_vs_ncbi.chr4_augustus.gff3.tmap | cut -f3 | sort | uniq -c | sort -nr
