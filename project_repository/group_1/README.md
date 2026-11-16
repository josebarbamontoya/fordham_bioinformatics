## Required Analyses

Each group will complete the following analyses with its ten genes. Examples of tools are given in parentheses, but you may use any appropriate tool, provided you justify your choice in the tutorial.

1. **Identify the genes.** Use BLAST to identify each of the ten genes (for example, BLAST against the NCBI nucleotide database). Report the gene name and a brief description of its function.
2. **Align the sequences.** Build a multiple sequence alignment (MSA) for each gene (for example, MAFFT or MACSE). Summarize the alignments in a table showing, for each gene, the number of sequences, the alignment length (number of sites), and the number of parsimony-informative sites (for example, AMAS).
3. **Infer gene trees.** For each MSA, select the best-fitting substitution model and infer a maximum likelihood (ML) tree with branch support values (for example, IQ-TREE with ModelFinder and ultrafast bootstrap).
4. **Infer a concatenated tree.** Concatenate the ten alignments into a single supermatrix and infer an ML tree, using a partitioned analysis with the best-fitting model for each partition (for example, IQ-TREE with a partition file).
5. **Infer a species tree under the multispecies coalescent.** Use the ten ML gene trees from step 3 to estimate a species tree (for example, ASTRAL).
6. **Plot the trees.** Plot the concatenated ML tree and the ASTRAL species tree, rooted with the appropriate outgroup and showing branch support values (for example, FigTree, Python).
7. **Compare the trees and discuss.** Compare the two trees and identify any nodes where they differ (for example, using the Robinson–Foulds distance). Discuss possible reasons for any differences, such as incomplete lineage sorting, gene tree estimation error, limited phylogenetic signal in individual genes, or model choice. If the trees agree, discuss why.
