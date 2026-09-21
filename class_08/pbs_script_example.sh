#!/bin/bash

#PBS -V
#PBS -N iqtree_concat_01
#PBS -q batch
#PBS -S /bin/bash
#PBS -m abe
#PBS -M jbarba@amnh.org
#PBS -e /home/jbarba/HPL_RUNS/<ERROR FILE NAME>
#PBS -o /home/jbarba/HPL_RUNS/<OUTPUT FILE NAME>
#PBS -l ncpus=30
#PBS -l mem=100G
#PBS -l walltime=500:00:00
cd $PBS_O_WORKDIR
echo Working directory is $PBS_O_WORKDIR

### load module
module load IQ-TREE/2.3.6-gompi-2024a

### my code lines
cd /home/jbarba/nas4/thelyphonid_uce_analysis/all_uce_loci/

iqtree -s concatenation_alignment.fas -m MFP -b 10 -nt 30
