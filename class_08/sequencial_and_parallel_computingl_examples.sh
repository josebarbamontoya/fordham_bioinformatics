#!/bin/bash

########################################################
##### Serial and Parallel Computing Examples ###########
##### Jose Barba #######################################
########################################################

### Serial code lines ###

cd /home/jbarba/nas4/canid_genome_sequences

iqtree -s locus_01.fasta -m MFP -nt 10 > screen01.txt
iqtree -s locus_02.fasta -m MFP -nt 10 > screen02.txt
iqtree -s locus_03.fasta -m MFP -nt 10 > screen03.txt


### Serial loop ###

cd /home/jbarba/nas4/canid_genome_sequences

for file in *.fasta
do
    iqtree -s "$file" -m MFP -nt 10
done


### Parallel code lines ###

cd /home/jbarba/nas4/canid_genome_sequences

iqtree -s locus_01.fasta -m MFP -nt 10 > screen01.txt &
iqtree -s locus_02.fasta -m MFP -nt 10 > screen02.txt &
iqtree -s locus_03.fasta -m MFP -nt 10 > screen03.txt &

wait


### Parallel loop ###

cd /home/jbarba/nas4/canid_genome_sequences

for file in *.fasta
do
    iqtree -s "$file" -m MFP -nt 10 &
done

wait

