#!/bin/bash

##################################
##### BLAST+ Search Tutorial #####
##### Jose Barba #################
##################################

### connect to the remote server erdos using ssh:
ssh erdos_username@erdos.dsm.fordham.edu

### change to the home directory
cd ~

### copy mafft to the current directory (.)
cp -r /u/erdos/jbarba/public/blast_search_tutorial .

##################################
##### Create BLAST Databases #####
##################################

### create a genome database of Drosophila melanogaster
/u/erdos/jbarba/public/ncbi-blast-2.17.0+/bin/makeblastdb \
  -in /u/erdos/jbarba/blast_search_tutorial/GCF_000001215.4/ncbi_dataset/data/GCF_000001215.4/GCF_000001215.4_Release_6_plus_ISO1_MT_genomic.fna \
  -dbtype nucl \
  -out /u/erdos/jbarba/blast_search_tutorial/GCF_000001215.4/ncbi_dataset/data/GCF_000001215.4/fruit_fly_genome_db \
  -parse_seqids

### create a cds database of Drosophila melanogaster
/u/erdos/jbarba/public/ncbi-blast-2.17.0+/bin/makeblastdb \
  -in /u/erdos/jbarba/blast_search_tutorial/GCF_000001215.4/ncbi_dataset/data/GCF_000001215.4/cds_from_genomic.fna \
  -dbtype nucl \
  -out /u/erdos/jbarba/blast_search_tutorial/GCF_000001215.4/ncbi_dataset/data/GCF_000001215.4/fruit_fly_cds_db \
  -parse_seqids

### create a protein database Drosophila melanogaster
/u/erdos/jbarba/public/ncbi-blast-2.17.0+/bin/makeblastdb \
  -in /u/erdos/jbarba/blast_search_tutorial/GCF_000001215.4/ncbi_dataset/data/GCF_000001215.4/protein.faa \
  -dbtype prot \
  -out /u/erdos/jbarba/blast_search_tutorial/GCF_000001215.4/ncbi_dataset/data/GCF_000001215.4/fruit_fly_protein_db \
  -parse_seqids

############################################################################
##### BLASTN Genome Search: Apis mellifera vs. Drosophila melanogaster #####
############################################################################

### run blastn (megablast)
/u/erdos/jbarba/public/ncbi-blast-2.17.0+/bin/blastn \
  -query /u/erdos/jbarba/blast_search_tutorial/GCF_003254395.2/ncbi_dataset/data/GCF_003254395.2/cds_from_genomic.fna \
  -db /u/erdos/jbarba/blast_search_tutorial/GCF_000001215.4/ncbi_dataset/data/GCF_000001215.4/fruit_fly_genome_db \
  -out /u/erdos/jbarba/blast_search_tutorial/am_genome_blastout_megablast.txt \

### run blastn (too slow; do not run this command)
#/u/erdos/jbarba/public/ncbi-blast-2.17.0+/bin/blastn \
#  -query /u/erdos/jbarba/blast_search_tutorial/GCF_003254395.2/ncbi_dataset/data/GCF_003254395.2/cds_from_genomic.fna \
#  -db /u/erdos/jbarba/blast_search_tutorial/GCF_000001215.4/ncbi_dataset/data/GCF_000001215.4/fruit_fly_genome_db \
#  -task blastn \
#  -out /u/erdos/jbarba/blast_search_tutorial/am_genome_blastout_blastn.txt \

##########################################################################
##### BLASTN Gene Search: Apis mellifera vs. Drosophila melanogaster #####
##########################################################################

### run blastn
/u/erdos/jbarba/public/ncbi-blast-2.17.0+/bin/blastn \
  -query /u/erdos/jbarba/blast_search_tutorial/am_beta_tubulin.fasta \
  -db /u/erdos/jbarba/blast_search_tutorial/GCF_000001215.4/ncbi_dataset/data/GCF_000001215.4/fruit_fly_cds_db \
  -task blastn \
  -out /u/erdos/jbarba/blast_search_tutorial/am_beta_tubulin_blastout.txt \

### run blastn
/u/erdos/jbarba/public/ncbi-blast-2.17.0+/bin/blastn \
  -query /u/erdos/jbarba/blast_search_tutorial/am_cox1.fasta \
  -db /u/erdos/jbarba/blast_search_tutorial/GCF_000001215.4/ncbi_dataset/data/GCF_000001215.4/fruit_fly_cds_db \
  -task blastn \
  -out /u/erdos/jbarba/blast_search_tutorial/am_cox1_blastout.txt \

### run blastn
/u/erdos/jbarba/public/ncbi-blast-2.17.0+/bin/blastn \
  -query /u/erdos/jbarba/blast_search_tutorial/am_cytb.fasta \
  -db /u/erdos/jbarba/blast_search_tutorial/GCF_000001215.4/ncbi_dataset/data/GCF_000001215.4/fruit_fly_cds_db \
  -task blastn \
  -out /u/erdos/jbarba/blast_search_tutorial/am_cytb_blastout.txt \

### run blastn
/u/erdos/jbarba/public/ncbi-blast-2.17.0+/bin/blastn \
  -query /u/erdos/jbarba/blast_search_tutorial/am_ef-1alpha.fasta \
  -db /u/erdos/jbarba/blast_search_tutorial/GCF_000001215.4/ncbi_dataset/data/GCF_000001215.4/fruit_fly_cds_db \
  -task blastn \
  -out /u/erdos/jbarba/blast_search_tutorial/am_ef-1alpha_blastout.txt \

### run blastn gene collection
/u/erdos/jbarba/public/ncbi-blast-2.17.0+/bin/blastn \
  -query /u/erdos/jbarba/blast_search_tutorial/am_gene_collection.fasta \
  -db /u/erdos/jbarba/blast_search_tutorial/GCF_000001215.4/ncbi_dataset/data/GCF_000001215.4/fruit_fly_cds_db \
  -task blastn \
  -out /u/erdos/jbarba/blast_search_tutorial/am_gene_collection_blastout.txt \

#########################################################################################
##### BLASTN rRNA Genes Search: Drosophila melanogaster vs. Drosophila melanogaster #####
#########################################################################################

### run blastn
/u/erdos/jbarba/public/ncbi-blast-2.17.0+/bin/blastn \
  -query /u/erdos/jbarba/blast_search_tutorial/dm_12s_rrna_gb_nuc.fasta \
  -db /u/erdos/jbarba/blast_search_tutorial/GCF_000001215.4/ncbi_dataset/data/GCF_000001215.4/fruit_fly_genome_db \
  -out /u/erdos/jbarba/blast_search_tutorial/dm_12s_rrna_blastout.txt

### run blastn 
/u/erdos/jbarba/public/ncbi-blast-2.17.0+/bin/blastn \
  -query /u/erdos/jbarba/blast_search_tutorial/dm_16s_rrna_gb_nuc.fasta \
  -db /u/erdos/jbarba/blast_search_tutorial/GCF_000001215.4/ncbi_dataset/data/GCF_000001215.4/fruit_fly_genome_db \
  -out /u/erdos/jbarba/blast_search_tutorial/dm_16s_rrna_blastout.txt

### run blastn 
/u/erdos/jbarba/public/ncbi-blast-2.17.0+/bin/blastn \
  -query /u/erdos/jbarba/blast_search_tutorial/dm_18s_rrna_gb_nuc.fasta \
  -db /u/erdos/jbarba/blast_search_tutorial/GCF_000001215.4/ncbi_dataset/data/GCF_000001215.4/fruit_fly_genome_db \
  -out /u/erdos/jbarba/blast_search_tutorial/dm_18s_rrna_blastout.txt 

### run blastn
/u/erdos/jbarba/public/ncbi-blast-2.17.0+/bin/blastn \
  -query /u/erdos/jbarba/blast_search_tutorial/dm_28s_rrna_gb_nuc.fasta \
  -db /u/erdos/jbarba/blast_search_tutorial/GCF_000001215.4/ncbi_dataset/data/GCF_000001215.4/fruit_fly_genome_db \
  -out /u/erdos/jbarba/blast_search_tutorial/dm_28s_rrna_blastout.txt

### run blastn gene collection
/u/erdos/jbarba/public/ncbi-blast-2.17.0+/bin/blastn \
  -query /u/erdos/jbarba/blast_search_tutorial/dm_gene_collection.fasta \
  -db /u/erdos/jbarba/blast_search_tutorial/GCF_000001215.4/ncbi_dataset/data/GCF_000001215.4/fruit_fly_genome_db \
  -out /u/erdos/jbarba/blast_search_tutorial/dm_gene_collection_blastout.txt

#############################################################################
##### BLASTP protein Search: Apis mellifera vs. Drosophila melanogaster #####
#############################################################################

### run blastp
/u/erdos/jbarba/public/ncbi-blast-2.17.0+/bin/blastp \
  -query /u/erdos/jbarba/blast_search_tutorial/am_prot_beta_tubulin.fasta \
  -db /u/erdos/jbarba/blast_search_tutorial/GCF_000001215.4/ncbi_dataset/data/GCF_000001215.4/fruit_fly_protein_db \
  -out /u/erdos/jbarba/blast_search_tutorial/am_prot_beta_tubulin_blastout.txt

### run blastp
/u/erdos/jbarba/public/ncbi-blast-2.17.0+/bin/blastp \
  -query /u/erdos/jbarba/blast_search_tutorial/am_prot_cox1.fasta \
  -db /u/erdos/jbarba/blast_search_tutorial/GCF_000001215.4/ncbi_dataset/data/GCF_000001215.4/fruit_fly_protein_db \
  -out /u/erdos/jbarba/blast_search_tutorial/am_prot_cox1_blastout.txt

### run blastp
/u/erdos/jbarba/public/ncbi-blast-2.17.0+/bin/blastp \
  -query /u/erdos/jbarba/blast_search_tutorial/am_prot_cytb.fasta \
  -db /u/erdos/jbarba/blast_search_tutorial/GCF_000001215.4/ncbi_dataset/data/GCF_000001215.4/fruit_fly_protein_db \
  -out /u/erdos/jbarba/blast_search_tutorial/am_prot_cytb_blastout.txt

### run blastp
/u/erdos/jbarba/public/ncbi-blast-2.17.0+/bin/blastp \
  -query /u/erdos/jbarba/blast_search_tutorial/am_prot_ef-1alpha.fasta \
  -db /u/erdos/jbarba/blast_search_tutorial/GCF_000001215.4/ncbi_dataset/data/GCF_000001215.4/fruit_fly_protein_db \
  -out /u/erdos/jbarba/blast_search_tutorial/am_prot_ef-1alpha_blastout.txt

### run blastp protein collection
/u/erdos/jbarba/public/ncbi-blast-2.17.0+/bin/blastp \
  -query /u/erdos/jbarba/blast_search_tutorial/am_prot_gene_collection.fasta \
  -db /u/erdos/jbarba/blast_search_tutorial/GCF_000001215.4/ncbi_dataset/data/GCF_000001215.4/fruit_fly_protein_db \
  -out /u/erdos/jbarba/blast_search_tutorial/am_prot_gene_collection_blastout.txt

#############################################################################################
##### BLASTX, TBLASTN, and TBLASTX Searches: Apis mellifera vs. Drosophila melanogaster #####
#############################################################################################

### run blastx
/u/erdos/jbarba/public/ncbi-blast-2.17.0+/bin/blastx \
  -query /u/erdos/jbarba/blast_search_tutorial/am_cox1.fasta \
  -db /u/erdos/jbarba/blast_search_tutorial/GCF_000001215.4/ncbi_dataset/data/GCF_000001215.4/fruit_fly_protein_db \
  -out /u/erdos/jbarba/blast_search_tutorial/am_cox1_blastx_out.txt

### run tblastn
/u/erdos/jbarba/public/ncbi-blast-2.17.0+/bin/tblastn \
  -query /u/erdos/jbarba/blast_search_tutorial/am_prot_cox1.fasta \
  -db /u/erdos/jbarba/blast_search_tutorial/GCF_000001215.4/ncbi_dataset/data/GCF_000001215.4/fruit_fly_genome_db \
  -out /u/erdos/jbarba/blast_search_tutorial/am_prot_cox1_tblastn_out.txt

### run tblastx
/u/erdos/jbarba/public/ncbi-blast-2.17.0+/bin/tblastx \
  -query /u/erdos/jbarba/blast_search_tutorial/am_cox1.fasta \
  -db /u/erdos/jbarba/blast_search_tutorial/GCF_000001215.4/ncbi_dataset/data/GCF_000001215.4/fruit_fly_genome_db \
  -out /u/erdos/jbarba/blast_search_tutorial/am_cox1_tblastx_out.txt
