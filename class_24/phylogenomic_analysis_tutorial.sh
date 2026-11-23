#!/bin/bash

######################################################
##### Phylogenomic Analysis - IQ-TREE and ASTRAL #####
##### Jose Barba #####################################
######################################################

### NOTE: run these commands one section at a time, not as a single script

### connect to the remote server erdos using ssh (replace erdos_username with your own username)
ssh erdos_username@erdos.dsm.fordham.edu

### copy mafft to the home directory if you do not have it yet
cp /u/erdos/jbarba/public/mafft-7.526-linux.tgz ~/

### uncompress mafft
tar xfvz mafft-7.526-linux.tgz

### copy the phylogenomic_analysis dataset to the home directory
cp -r /u/erdos/jbarba/public/phylogenomic_analysis ~/

### activate the python environment
conda activate bioinformatics

### install astral, gotree, biopython, and matplotlib
conda install -c bioconda -c conda-forge astral-tree gotree biopython matplotlib

###########################
##### mafft alignment #####
###########################

### change to the directory with the unaligned loci
cd ~/phylogenomic_analysis/orthomam_dataset

### mafft alignment (loop)
for file in *.fasta; do
    ~/mafft-linux64/mafft.bat --auto "$file" > "${file%.fasta}_mafft.fasta"
done

### copy the mafft alignments to iqtree_analysis
cp *_mafft.fasta ~/phylogenomic_analysis/iqtree_analysis/

###########################
##### iqtree analysis #####
###########################

### change to the iqtree_analysis directory
cd ~/phylogenomic_analysis/iqtree_analysis

### iqtree analysis of each locus (loop)
for file in *_mafft.fasta; do
    iqtree2 -s "$file" -m MFP -B 1000 -bnni -T 5
done

### create the aligned directory for the iqtree concatenated partitioned analysis
mkdir ~/phylogenomic_analysis/iqtree_analysis/aligned

### copy the mafft alignments to the aligned directory
cp *_mafft.fasta ~/phylogenomic_analysis/iqtree_analysis/aligned/

### iqtree concatenated partitioned analysis
iqtree2 -p aligned/ -m MFP -B 1000 -bnni -T 5 --prefix concatenated_partitioned

### inspect the concatenated partitioned analysis results
cat concatenated_partitioned.iqtree
cat concatenated_partitioned.log
cat concatenated_partitioned.treefile

### extract the best-fit substitution model of each locus
grep "Best-fit model according to BIC:" *_mafft.fasta.iqtree | tee iqtree_substitution_models.txt

### extract the best-fit substitution model of each locus in the concatenation
cat concatenated_partitioned.best_scheme.nex | tee iqtree_concatenation_models.txt

### extract the log-likelihood of each gene tree and the concatenation tree
grep "BEST SCORE FOUND :" *.log | tee iqtree_tree_likelihoods.txt

### sum the log-likelihoods of the ten gene trees
grep "BEST SCORE FOUND :" *_mafft.fasta.log | awk '{sum += $NF} END {printf "Sum of gene tree log-likelihoods: %.3f\n", sum}'

###########################
##### astral analysis #####
###########################

### create the astral_analysis directory
mkdir -p ~/phylogenomic_analysis/astral_analysis

### combine the ten ML locus trees into one file in the astral_analysis directory
cat *_mafft.fasta.treefile > ~/phylogenomic_analysis/astral_analysis/10_ml_trees.nwk

### change to the astral_analysis directory
cd ~/phylogenomic_analysis/astral_analysis

### run astral with local posterior probabilities (lpp)
astral -i 10_ml_trees.nwk -o astral_tree.nwk 2> out.log

### inspect the astral log
cat out.log

###########################################################
##### iqtree concatenation and astral tree comparison #####
###########################################################

### create the tree_comparison directory
mkdir ~/phylogenomic_analysis/tree_comparison

### copy the iqtree and astral trees
cp ~/phylogenomic_analysis/iqtree_analysis/concatenated_partitioned.treefile ~/phylogenomic_analysis/tree_comparison/
cp ~/phylogenomic_analysis/astral_analysis/astral_tree.nwk ~/phylogenomic_analysis/tree_comparison/

### change to the tree_comparison directory
cd ~/phylogenomic_analysis/tree_comparison

### place the outgroup (og) Ornithorhynchus_anatinus at the base of the iqtree and astral trees
gotree reroot outgroup -i concatenated_partitioned.treefile Ornithorhynchus_anatinus | gotree unroot -o concatenated_partitioned_og_root.tree
gotree reroot outgroup -i astral_tree.nwk Ornithorhynchus_anatinus | gotree unroot -o astral_tree_og_root.nwk

### compute the RF and normalized RF distances between the concatenated and astral trees and save them to a file
rf=$(gotree compare trees --rf -i concatenated_partitioned_og_root.tree -c astral_tree_og_root.nwk)
n=$(gotree labels -i concatenated_partitioned_og_root.tree | wc -l)
awk -v rf=$rf -v n=$n 'BEGIN {printf "RF distance: %d\nMaximum RF: %d\nNormalized RF: %.3f\n", rf, 2*(n-3), rf/(2*(n-3))}' | tee rf_distance.txt

########################################
##### plot iqtree and astral trees #####
########################################

### create a plot of the concatenated and astral trees side by side, with the outgroup at the 
python - << 'EOF'
from Bio import Phylo
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

trees = [("concatenated_partitioned_og_root.tree", "ML concatenation tree (IQ-TREE)\nsupport: ultrafast bootstrap (%)"),
         ("astral_tree_og_root.nwk", "MSC tree (ASTRAL)\nsupport: local posterior probability")]

fig, axes = plt.subplots(1, 2, figsize=(14, 8))

for ax, (file, title) in zip(axes, trees):
    tree = Phylo.read(file, "newick")
    tree.ladderize(reverse=True)
    if "astral" in file:
        # ASTRAL tips have no branch lengths, so plot it as a cladogram
        for clade in tree.find_clades():
            clade.branch_length = 1
    for tip in tree.get_terminals():
        tip.name = tip.name.replace("_", " ")
    Phylo.draw(tree, axes=ax, do_show=False,
               label_func=lambda c: c.name if c.is_terminal() else None,
               branch_labels=lambda c: c.confidence if not c.is_terminal() else None)
    ax.set_title(title, fontsize=11)
    ax.set_ylabel("")
    ax.set_yticks([])
    for side in ("top", "right", "left"):
        ax.spines[side].set_visible(False)

axes[0].set_xlabel("substitutions per site")
axes[1].set_xlabel("")
axes[1].set_xticks([])
axes[1].spines["bottom"].set_visible(False)

plt.tight_layout()
plt.savefig("tree_comparison.pdf")
plt.savefig("tree_comparison.png", dpi=300)
EOF

###########################################################
##### gene, concatenation, and astral tree comparison #####
###########################################################

### copy the ten ML locus trees to the tree_comparison directory
cp ~/phylogenomic_analysis/astral_analysis/10_ml_trees.nwk ~/phylogenomic_analysis/tree_comparison/

### compute the RF and normalized RF distances between each locus tree and the concatenation and astral trees
n=$(gotree labels -i concatenated_partitioned_og_root.tree | wc -l)
max=$((2 * (n - 3)))

printf "tree\tRF_concatenation\tnRF_concatenation\tRF_astral\tnRF_astral\n" > locus_tree_rf.tsv

paste <(gotree compare trees --rf -i concatenated_partitioned_og_root.tree -c 10_ml_trees.nwk) \
      <(gotree compare trees --rf -i astral_tree_og_root.nwk -c 10_ml_trees.nwk) |
awk -v m=$max '{printf "%d\t%d\t%.3f\t%d\t%.3f\n", NR, $1, $1/m, $2, $2/m}' >> locus_tree_rf.tsv

cat locus_tree_rf.tsv

### deactivate the conda environment
conda deactivate

####################################################
##### transfer phylogenomic_analysis directory #####
####################################################
 
### exit the erdos server
exit

##### run the following from your own computer #####

### in mac and linux (terminal): transfer the phylogenomic_analysis directory to your home directory
### NOTE: SUBSTITUTE USERNAME WITH YOUR OWN ERDOS USERNAME
scp -r username@erdos.dsm.fordham.edu:~/phylogenomic_analysis ~/

### in windows (powershell): transfer the phylogenomic_analysis directory to your home directory
### NOTE: SUBSTITUTE USERNAME WITH YOUR OWN ERDOS USERNAME
scp -r username@erdos.dsm.fordham.edu:~/phylogenomic_analysis "$HOME"
