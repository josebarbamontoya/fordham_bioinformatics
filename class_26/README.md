# Class 26

* ## Machine learning in bioinformatics

## Instructions to download the SNPs PCA analysis example using scikit-learn to your home directory:
1.- Open the terminal (Windows users: open PowerShell)

2.- Enter the command `cd ~`

3a.- Mac or Unix/Unix-like system users, enter the command (all in one line): `wget https://raw.githubusercontent.com/josebarbamontoya/fordham_bioinformatics/main/class_26/snp_pca_analysis_scikit-learn.zip`

> If `wget` is not available, use `curl -O` instead of `wget`

3b.- Windows users, enter the command (all in one line): `Invoke-WebRequest https://raw.githubusercontent.com/josebarbamontoya/fordham_bioinformatics/main/class_26/snp_pca_analysis_scikit-learn.zip -OutFile snp_pca_analysis_scikit-learn.zip`

4a.- Mac or Unix/Unix-like system users, unzip the directory: `unzip snp_pca_analysis_scikit-learn.zip`

4b.- Windows users, unzip the directory: `tar -xf snp_pca_analysis_scikit-learn.zip`

## The `snp_pca_analysis_scikit-learn.zip` file contains four files:

* `snp_pca_analysis_scikit-learn.sh`: step-by-step commands to run the analysis on the erdos server.

* `simulate_snps.py`: Python script used to simulate the SNP genotype data for three populations (Pop_A, Pop_B, and Pop_C). It draws an ancestral allele frequency for each SNP, shifts the frequencies slightly in each population to mimic genetic drift, and draws two alleles per SNP for each individual.

* `snp_genotypes.csv`: input data produced by `simulate_snps.py`, with 90 individuals (30 per population) and 500 SNPs. The first two columns are `individual` and `population`, followed by one column per SNP. Each genotype is coded as the number of copies of the alternative allele: 0, 1, or 2. The data are simulated, not from real individuals.

* `pca_snp.py`: Python script that runs the PCA with scikit-learn. It standardizes each SNP, computes the first 10 principal components, and writes four output files:
  * `pca_scores.csv`: PC1 to PC10 for each individual
  * `pca_variance.csv`: percentage of variance explained by each principal component
  * `pca_top_snps.csv`: the 10 SNPs with the largest loadings on PC1 and on PC2, with the mean genotype in each population
  * `pca_snp_plot.png`: plot of PC1 versus PC2 and the scree plot

To run the analysis, change to the directory and run the script: `cd snp_pca_analysis_scikit-learn` and then `python3 pca_snp.py snp_genotypes.csv`
