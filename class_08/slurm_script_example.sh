#!/bin/bash

#SBATCH --partition=batch # or 'bigmem' or 'gpu'
#SBATCH --job-name=iqtree_concat_01
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=30
#SBATCH --mem=100G
#SBATCH --time=500:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=jbarba@amnh.org
#SBATCH --output=output_file.txt
#SBATCH --error=error_file.txt
cd $SLURM_SUBMIT_DIR
echo Working directory is $SLURM_SUBMIT_DIR

### load module
module load IQ-TREE/2.3.6-gompi-2024a

### my code lines
cd /home/jbarba/nas4/thelyphonid_uce_analysis/all_uce_loci/

iqtree -s concatenation_alignment.fas -m MFP -b 10 -nt 30
