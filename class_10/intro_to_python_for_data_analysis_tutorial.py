#!/usr/bin/python3

#############################################################
##### Introduction to Python for Data Analysis Tutorial #####
##### Jose Barba ############################################
#############################################################

####################################################################
##### part 00 ######################################################
####################################################################
####################################################################
##### installation of required python packages for the tutoial #####
####################################################################

### install required packages
import subprocess
import sys

packages = [
    "requests",
    "numpy",
    "matplotlib",
    "scipy",
    "biopython",
    "dendropy",
    "pandas",
    "statsmodels"
]

subprocess.check_call(
    [sys.executable, "-m", "pip", "install", "--user"] + packages
)

### import required packages
import os
import requests
import numpy as np
import matplotlib.pyplot as plt
from itertools import combinations
from scipy import stats
from Bio import AlignIO, Phylo
from Bio.Phylo.TreeConstruction import DistanceCalculator, DistanceTreeConstructor
import dendropy
from dendropy.calculate import treecompare
import pandas as pd
from io import StringIO
import statsmodels.api as sm
from scipy.stats import pearsonr
from scipy.stats import gaussian_kde

#########################################################
##### part 01 ###########################################
#########################################################
#########################################################
##### data manipulation, analysis and visualization #####
#########################################################

### create a new directory 'ncbi_refseq_genome_statistics'
### NOTE: SUBSTITUTE THE PATH WITH YOUR OWN
os.makedirs("/Users/barba/Desktop/ncbi_refseq_genome_statistics", exist_ok=True)

### set working directory
### NOTE: SUBSTITUTE THE PATH WITH YOUR OWN
working_directory = "/Users/barba/Desktop/ncbi_refseq_genome_statistics"
os.chdir(working_directory)

### display current working directory
os.getcwd()

### download a summary of current NCBI RefSeq genome assemblie
import urllib.request

urllib.request.urlretrieve(
    "https://ftp.ncbi.nlm.nih.gov/genomes/ASSEMBLY_REPORTS/assembly_summary_refseq.txt",
    "assembly_summary_refseq.txt"
)

urllib.request.urlretrieve(
    "https://ftp.ncbi.nlm.nih.gov/genomes/README_assembly_summary.txt",
    "README_assembly_summary.txt"
)

### open and read the file
with open("assembly_summary_refseq.txt", "r") as file:
    g_data = file.read()

### remove the '#' symbol from each line
cleaned_lines = [line.replace("#", "") for line in g_data]

### convert cleaned lines to a dataframe, skipping the first line
### use stringio to read the cleaned lines as a cvs-like structure
data_string = "".join(cleaned_lines)
g_data = pd.read_csv(StringIO(data_string), sep="\t", skiprows=1, quoting=3, engine='python')

### export the edited dataframed to a new file
g_data.to_csv("assembly_summary_refseq_cleaned.txt", sep="\t", index=False, quoting=3)

### read the cleaned dataframe with low_memory set to false
g_data = pd.read_csv("assembly_summary_refseq_cleaned.txt", sep="\t", low_memory=False)

### count number of rows (genomes) and columns (variables) 
### number of rows
num_rows = g_data.shape[0]
### number of columns
num_cols = g_data.shape[1]
### print numbers
print(f"Number of genomes: {num_rows}")
print(f"Number of variables: {num_cols}")

### count number of genomes for each major lineage
genome_counts = g_data['group'].value_counts()

### genome counts for each major lineage #####
print("\nGenome counts for each major lineage:")
print(genome_counts)

######################################################################
##### create a bar plot number of genomes for each major lineage #####
######################################################################

plt.figure(figsize=(10, 6))
plt.bar(genome_counts.index, genome_counts.values, color='red')

plt.xlabel("Major lineage")
plt.ylabel("Number of genomes")
plt.title("Number of genomes for each major lineage")
plt.xticks(rotation=45)
plt.show()

##### summary statistics of gc percent #####
print("Summary statistics for GC percent:")
gc_percent_summary = g_data['gc_percent'].describe() 
print(gc_percent_summary)

### statistical measures of gc percent
mean_gc = g_data['gc_percent'].mean()
median_gc = g_data['gc_percent'].median()
min_gc = g_data['gc_percent'].min()
max_gc = g_data['gc_percent'].max()

### print statistics
print("Some statistics measures for GC percent:")
print(f"Mean GC percent: {mean_gc}")
print(f"Median GC percent: {median_gc}")
print(f"Min GC percent: {min_gc}")
print(f"Max GC percent: {max_gc}")

############################################
##### create a histogram of gc content #####
############################################
plt.figure(figsize=(10, 6))
plt.hist(g_data['gc_percent'], bins=30, color='red')
plt.title('GC Content Histogram')
plt.xlabel('GC Percentage')
plt.ylabel('Frequency')
plt.grid(axis='y', alpha=0.75)
plt.show()

#########################################################
##### create a boxplot of gc content for each group #####
#########################################################

# sort table by group
sorted_table = g_data.sort_values(by='group')

# collect gc content for each group
groups = sorted_table.groupby('group')['gc_percent']

# create a boxplot
plt.figure(figsize=(10, 6))
plt.boxplot(
    [data.dropna() for name, data in groups],
    labels=[name for name, data in groups],
    medianprops=dict(color="red")
)

plt.title("GC content by major lineage")
plt.ylabel("GC content (%)")
plt.xticks(rotation=45)
plt.show()

##########################################################
##### create a boxplot of genome size for each group #####
##########################################################

### sort table by group
sorted_table = g_data.sort_values(by='group')

### collect genome size for each group
groups = sorted_table.groupby('group')['genome_size']

### create a boxplot
plt.figure(figsize=(10, 6))
plt.boxplot(
    [data.dropna() for name, data in groups],
    labels=[name for name, data in groups],
    medianprops=dict(color="red")
)

plt.title("Genome size by major lineage")
plt.ylabel("Genome size (bp)")
plt.xticks(rotation=45)
plt.show()

### compute and print genmome size statistics
print(f"Mean genome size (bp): {g_data['genome_size'].mean()}")
print(f"Median genome size (bp): {g_data['genome_size'].median()}")
print(f"Min genome size (bp): {g_data['genome_size'].min()}")
print(f"Max genome size (bp): {g_data['genome_size'].max()}")

#######################################################
##### create a barplot pof the 10 largest genomes #####
#######################################################

### convert genome size to numeric
g_data['genome_size'] = pd.to_numeric(
    g_data['genome_size'],
    errors='coerce'
)

### select the 10 largest genomes
largest_genomes = g_data.nlargest(10, 'genome_size')

### create bar plot
plt.figure(figsize=(10, 6))

plt.bar(
    largest_genomes['organism_name'],
    largest_genomes['genome_size'],
    color='red'
)

plt.xlabel("Organism")
plt.ylabel("Genome size (bp)")
plt.title("Ten largest genomes")

plt.xticks(rotation=45, ha='right')

plt.tight_layout()
plt.show()

#########################################################
##### create a barplot pof the 10 smallest genomes ######
#########################################################

### select the 10 smallest genomes
smallest_genomes = g_data.nsmallest(10, 'genome_size')

### create bar plot
plt.figure(figsize=(10, 6))

plt.bar(
    smallest_genomes['organism_name'],
    smallest_genomes['genome_size'],
    color='red'
)

plt.xlabel("Organism")
plt.ylabel("Genome size (bp)")
plt.title("Ten smallest genomes")

plt.xticks(rotation=45, ha='right')

plt.tight_layout()
plt.show()

###################################################################
##### create a scatterplot of genome size and number of genes #####
###################################################################

### ensure the columns are numeric and remove missing values
g_data_clean = g_data[['genome_size', 'total_gene_count']].apply(pd.to_numeric, errors='coerce').dropna()

### create the scatterplot of genome size vs number of genes 
plt.figure(figsize=(8, 6))
plt.scatter(g_data_clean['genome_size'], g_data_clean['total_gene_count'], color='black')
plt.title("Genome size vs number of genes")
plt.xlabel("Genome Size")
plt.ylabel("Total gene count")

### fit a linear regression line through the origin 
X = g_data_clean['genome_size'].values.reshape(-1, 1)
Y = g_data_clean['total_gene_count'].values 

### perform linear regression through the origin (no constant term)
model = sm.OLS(Y, X)  # no constant term here, which implies regression through the origin
results = model.fit()

### plot the regression line 
plt.plot(g_data_clean['genome_size'], results.predict(), color='red', linewidth=1)
plt.show()

### compute the correlation (pearson correlation coefficient)
correlation, p_value = pearsonr(g_data_clean['genome_size'], g_data_clean['total_gene_count'])
print(f"Pearson Correlation: {correlation:.3f}, p-value: {p_value:.3e}")

### display the linear regression summary
print(results.summary())

############################################################################
##### create a stacked barplot of coding and non-coding genes by group #####
############################################################################

### ensure the gene-count columns are numeric
g_data_clean = g_data[['group',
                       'protein_coding_gene_count',
                       'non_coding_gene_count']].copy()

g_data_clean[['protein_coding_gene_count',
              'non_coding_gene_count']] = (
    g_data_clean[['protein_coding_gene_count',
                  'non_coding_gene_count']]
    .apply(pd.to_numeric, errors='coerce')
)

### remove rows with missing data
g_data_clean = g_data_clean.dropna()

### calculate mean gene counts for each group
gene_counts = g_data_clean.groupby('group')[
    ['protein_coding_gene_count', 'non_coding_gene_count']
].mean()

### create the stacked barplot
fig, ax = plt.subplots(figsize=(10, 6))

ax.bar(
    gene_counts.index,
    gene_counts['non_coding_gene_count'],
    color='red',
    label='Non-coding genes'
)

ax.bar(
    gene_counts.index,
    gene_counts['protein_coding_gene_count'],
    bottom=gene_counts['non_coding_gene_count'],
    color='blue',
    label='Protein-coding genes'
)

ax.set_title("Number of protein-coding and non-coding genes by group")
ax.set_ylabel("Gene count")
ax.set_xlabel("Major lineage")
ax.legend()

plt.xticks(rotation=45)
plt.tight_layout()
plt.show()

###################################################################
##### create boxplots of coding and non-coding genes by group #####
###################################################################

### ensure the gene-count columns are numeric
g_data_clean = g_data[['group',
                       'protein_coding_gene_count',
                       'non_coding_gene_count']].copy()

g_data_clean[['protein_coding_gene_count',
              'non_coding_gene_count']] = (
    g_data_clean[['protein_coding_gene_count',
                  'non_coding_gene_count']]
    .apply(pd.to_numeric, errors='coerce')
)

### remove rows with missing data
g_data_clean = g_data_clean.dropna()

### sort groups alphabetically
groups = sorted(g_data_clean['group'].unique())

### extract gene counts for each group
coding_data = [
    g_data_clean.loc[
        g_data_clean['group'] == group,
        'protein_coding_gene_count'
    ]
    for group in groups
]

noncoding_data = [
    g_data_clean.loc[
        g_data_clean['group'] == group,
        'non_coding_gene_count'
    ]
    for group in groups
]

### set positions for the boxplots
positions_coding = np.arange(len(groups)) * 2 - 0.4
positions_noncoding = np.arange(len(groups)) * 2 + 0.4

### create the boxplots
fig, ax = plt.subplots(figsize=(12, 6))

### protein-coding genes
ax.boxplot(
    coding_data,
    positions=positions_coding,
    widths=0.6,
    patch_artist=True,
    boxprops=dict(facecolor='blue'),
    medianprops=dict(color='black')
)

### non-coding genes
ax.boxplot(
    noncoding_data,
    positions=positions_noncoding,
    widths=0.6,
    patch_artist=True,
    boxprops=dict(facecolor='red'),
    medianprops=dict(color='black')
)

### format x-axis
ax.set_xticks(np.arange(len(groups)) * 2)
ax.set_xticklabels(groups, rotation=45)

### add labels and title
ax.set_title("Number of protein-coding and non-coding genes by group")
ax.set_ylabel("Gene count")
ax.set_xlabel("Major lineage")

### add legend
from matplotlib.patches import Patch

ax.legend(
    handles=[
        Patch(facecolor='blue', label='Protein-coding genes'),
        Patch(facecolor='red', label='Non-coding genes')
    ]
)

### adjust layout and display plot
plt.tight_layout()
plt.show()

### compute and print gene count tatistics
print(f"Mean coding genes count: {g_data_clean['protein_coding_gene_count'].mean()}")
print(f"Median coding genes count: {g_data_clean['protein_coding_gene_count'].median()}")
print(f"Min coding genes count: {g_data_clean['protein_coding_gene_count'].min()}")
print(f"Max coding genes count: {g_data_clean['protein_coding_gene_count'].max()}")
### compute and print gene count tatistics
print(f"Mean non-coding genes count: {g_data_clean['non_coding_gene_count'].mean()}")
print(f"Median non-coding genes count: {g_data_clean['non_coding_gene_count'].median()}")
print(f"Min non-coding genes count: {g_data_clean['non_coding_gene_count'].min()}")
print(f"Max non-coding genes count: {g_data_clean['non_coding_gene_count'].max()}")

###########################################################################################
##### create density plots of protein-coding and non-coding gene proportions by group #####
###########################################################################################

### remove rows with missing values
cleaned_df2 = g_data[
    ['group',
     'protein_coding_gene_count',
     'non_coding_gene_count']
].dropna()

### convert gene counts to numeric
cleaned_df2[
    ['protein_coding_gene_count',
     'non_coding_gene_count']
] = cleaned_df2[
    ['protein_coding_gene_count',
     'non_coding_gene_count']
].apply(pd.to_numeric, errors='coerce')

### calculate total gene count
total_genes = (
    cleaned_df2['protein_coding_gene_count'] +
    cleaned_df2['non_coding_gene_count']
)

### calculate proportions
cleaned_df2['coding_proportion'] = (
    cleaned_df2['protein_coding_gene_count'] /
    total_genes
)

cleaned_df2['non_coding_proportion'] = (
    cleaned_df2['non_coding_gene_count'] /
    total_genes
)

##### protein-coding gene proportion #####

plt.figure(figsize=(10, 6))

for group in sorted(cleaned_df2['group'].unique()):

    group_data = cleaned_df2.loc[
        cleaned_df2['group'] == group,
        'coding_proportion'
    ].dropna()

    density = gaussian_kde(group_data)

    x_vals = np.linspace(0, 1, 1000)

    plt.plot(
        x_vals,
        density(x_vals),
        lw=2,
        label=group
    )

plt.title("Distribution of the proportion of protein-coding genes by group")
plt.xlabel("Proportion of protein-coding genes")
plt.ylabel("Density")

plt.xlim(0, 1)

plt.legend(
    title="Group",
    bbox_to_anchor=(1.05, 1),
    loc='upper left'
)

plt.tight_layout()
plt.show()


##### non-coding gene proportion #####

plt.figure(figsize=(10, 6))

for group in sorted(cleaned_df2['group'].unique()):

    group_data = cleaned_df2.loc[
        cleaned_df2['group'] == group,
        'non_coding_proportion'
    ].dropna()

    density = gaussian_kde(group_data)

    x_vals = np.linspace(0, 1, 1000)

    plt.plot(
        x_vals,
        density(x_vals),
        lw=2,
        label=group
    )

plt.title("Distribution of the proportion of non-coding genes by group")
plt.xlabel("Proportion of non-coding genes")
plt.ylabel("Density")

plt.xlim(0, 1)

plt.legend(
    title="Group",
    bbox_to_anchor=(1.05, 1),
    loc='upper left'
)

plt.tight_layout()
plt.show()

#########################################################
##### create density plot of sequence release dates #####
#########################################################

### convert seq_rel_date to datetime
g_data_clean = g_data[['seq_rel_date']].copy()

g_data_clean['seq_rel_date'] = pd.to_datetime(
    g_data_clean['seq_rel_date'],
    errors='coerce'
)

### remove missing dates
g_data_clean = g_data_clean.dropna()

### extract the release year
release_year = g_data_clean['seq_rel_date'].dt.year

### calculate density
from scipy.stats import gaussian_kde

d1 = gaussian_kde(release_year)

### create x values for the density curve
x = np.linspace(
    release_year.min(),
    release_year.max(),
    500
)

### plot the density
plt.figure(figsize=(10, 6))

plt.plot(
    x,
    d1(x),
    linewidth=2,
    color='red'
)

plt.title("Distribution of genome sequence release dates")
plt.xlabel("Sequence release year")
plt.ylabel("Density")

plt.tight_layout()
plt.show()

######################################
##### part 02 ########################
######################################
######################################
##### Phylogenomic data analysis #####
######################################

### import required packages
import os
import requests
import numpy as np
from Bio import AlignIO, Phylo
from Bio.Phylo.TreeConstruction import DistanceCalculator, DistanceTreeConstructor
import dendropy
from dendropy.calculate import treecompare
import matplotlib.pyplot as plt
from itertools import combinations
from scipy import stats
import numpy as np
import matplotlib.pyplot as plt
import statsmodels.api as sm
from scipy.stats import pearsonr

### create a new directory 'ncbi_refseq_genome_statistics'
### NOTE: SUBSTITUTE THE PATH WITH YOUR OWN
os.makedirs("/Users/barba/Desktop/canid_phylo_analysis", exist_ok=True)

### set working directory
### NOTE: SUBSTITUTE THE PATH WITH YOUR OWN
working_directory = "/Users/barba/Desktop/canid_phylo_analysis"
os.chdir(working_directory)

### display current working directory
os.getcwd()

### download a FASTA MSA of 44 canid mt genomes
url = "https://raw.githubusercontent.com/josebarbamontoya/fordham_bioinformatics/main/class_10/44canid_mt_genomes.fasta"
response = requests.get(url)
response.raise_for_status()  # Raise an error for bad responses
with open("44canid_mt_genomes.fasta", "wb") as file:
    file.write(response.content)

### read fasta MSA
alignment = AlignIO.read("44canid_mt_genomes.fasta", "fasta")

### calculate distance matrix using the identity model
calculator = DistanceCalculator('identity')
dist_matrix = calculator.get_distance(alignment)

##############################################################
##### construct a tree using the neighbor-joining method #####
##############################################################

constructor = DistanceTreeConstructor()
nj_tree = constructor.nj(dist_matrix)

### plot the tree
fig, ax = plt.subplots(figsize=(15, 15))
Phylo.draw(
    nj_tree,
    axes=ax,
    do_show=True
)

### save the newick tree
Phylo.write(nj_tree, "nj_tree.nwk", "newick")

###################################################
##### construct a tree using the UPGMA method #####
###################################################

constructor = DistanceTreeConstructor()
upgma_tree = constructor.upgma(dist_matrix)

### plot the tree
fig, ax = plt.subplots(figsize=(15, 15))

Phylo.draw(
    upgma_tree,
    axes=ax,
    do_show=True
)

### save the Newick tree
Phylo.write(upgma_tree, "upgma_tree.nwk", "newick")

###############################################
##### sort and compare nj and upgma trees #####
###############################################

### create one shared taxon namespace
taxon_namespace = dendropy.TaxonNamespace()

### read NJ tree
nj_tree = dendropy.Tree.get(
    path="nj_tree.nwk",
    schema="newick",
    taxon_namespace=taxon_namespace
)

### read UPGMA tree using the same taxon namespace
upgma_tree = dendropy.Tree.get(
    path="upgma_tree.nwk",
    schema="newick",
    taxon_namespace=taxon_namespace
)

### unroot both trees
nj_tree.is_rooted = False
upgma_tree.is_rooted = False

##### calculate RF distance between nj and upgma trees #####

rf_distance = treecompare.symmetric_difference(
    nj_tree,
    upgma_tree
)

print(f"RF distance: {rf_distance}")

### calculate normalized RF distance
n = len(taxon_namespace)
max_rf = 2 * (n - 3)
normalized_rf = rf_distance / max_rf

print(f"Number of taxa: {n}")
print(f"Maximum RF distance: {max_rf}")
print(f"Normalized RF distance: {normalized_rf:.4f}")

####################################################################
##### plot the distribution of nj and upgma pairwise distances #####
####################################################################

### read trees
nj_tree = Phylo.read("nj_tree.nwk", "newick")
upgma_tree = Phylo.read("upgma_tree.nwk", "newick")

### calculate all pairwise distances
nj_pairwise_distances = [
    nj_tree.distance(t1, t2)
    for t1, t2 in combinations(nj_tree.get_terminals(), 2)
]

upgma_pairwise_distances = [
    upgma_tree.distance(t1, t2)
    for t1, t2 in combinations(upgma_tree.get_terminals(), 2)
]

### calculate density estimates
nj_density = stats.gaussian_kde(nj_pairwise_distances)
upgma_density = stats.gaussian_kde(upgma_pairwise_distances)

### x-axis range
x = np.linspace(
    0,
    max(max(nj_pairwise_distances), max(upgma_pairwise_distances)),
    500
)

### plot densities
plt.figure(figsize=(8, 6))

plt.plot(
    x,
    nj_density(x),
    label="NJ",
    linewidth=2,
    color="blue"
)

plt.plot(
    x,
    upgma_density(x),
    label="UPGMA",
    linewidth=2,
    color="red"
)

plt.xlabel("Pairwise distance")
plt.ylabel("Density")
plt.title("Distribution of pairwise distances")
plt.legend()

plt.tight_layout()
plt.show()

##############################################################################
##### create a scatterplot of pirwise of nj and upgma pairwise distances #####
##############################################################################

### read trees
nj_tree = Phylo.read("nj_tree.nwk", "newick")
upgma_tree = Phylo.read("upgma_tree.nwk", "newick")

### get terminals
nj_terminals = {terminal.name: terminal for terminal in nj_tree.get_terminals()}
upgma_terminals = {terminal.name: terminal for terminal in upgma_tree.get_terminals()}

### identify taxa shared by both trees
taxa = sorted(set(nj_terminals) & set(upgma_terminals))

### calculate pairwise distances
nj_pairwise_distances = []
upgma_pairwise_distances = []

for taxon1, taxon2 in combinations(taxa, 2):

    nj_pairwise_distances.append(
        nj_tree.distance(nj_terminals[taxon1], nj_terminals[taxon2])
    )

    upgma_pairwise_distances.append(
        upgma_tree.distance(
            upgma_terminals[taxon1],
            upgma_terminals[taxon2]
        )
    )

X = np.array(nj_pairwise_distances).reshape(-1, 1)
Y = np.array(upgma_pairwise_distances)

### perform linear regression through the origin
model = sm.OLS(Y, X)
results = model.fit()

### create scatterplot
plt.figure(figsize=(8, 6))

plt.scatter(
    nj_pairwise_distances,
    upgma_pairwise_distances,
    color="black"
)

### plot regression line
x_values = np.linspace(
    min(nj_pairwise_distances),
    max(nj_pairwise_distances),
    100
)

plt.plot(
    x_values,
    results.predict(x_values.reshape(-1, 1)),
    color="red",
    linewidth=1
)

### 1:1 reference line
min_distance = min(
    min(nj_pairwise_distances),
    min(upgma_pairwise_distances)
)

max_distance = max(
    max(nj_pairwise_distances),
    max(upgma_pairwise_distances)
)

plt.xlabel("NJ pairwise distance")
plt.ylabel("UPGMA pairwise distance")
plt.title("Pairwise distances: NJ vs. UPGMA")

plt.tight_layout()
plt.show()

### compute Pearson correlation
correlation, p_value = pearsonr(
    nj_pairwise_distances,
    upgma_pairwise_distances
)

print(f"Pearson Correlation: {correlation:.3f}")
print(f"p-value: {p_value:.3e}")

### display linear regression summary
print(results.summary())
