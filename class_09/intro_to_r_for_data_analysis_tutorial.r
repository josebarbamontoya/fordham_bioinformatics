#!/usr/bin/env Rscript

#########################################################
##### Introduction to R for Data Ananlysis Tutorial #####
##### Jose Barba ########################################
#########################################################

###############################################################
##### part 00 #################################################
###############################################################
###############################################################
##### installation of required r packages for the tutoial #####
###############################################################

install.packages("ggplot2")
install.packages("ape")
install.packages("phytools")
install.packages("dendextend")
install.packages("phangorn")
install.packages("vioplot")
install.packages("tidyverse")

#########################################################
##### part 01 ###########################################
#########################################################
#########################################################
##### data manipulation, analysis and visualization #####
#########################################################

### clear workspace
rm(list=ls())

### ensure the necessary packages are loaded
library(ggplot2)

### print your current working 
getwd()

### create a new directory 'ncbi_refseq_genome_statistics'
### NOTE: SUBSTITUTE THE PATH WITH YOUR OWN
dir.create("/Users/barba/Desktop/ncbi_refseq_genome_statistics")

### set working directory
### NOTE: SUBSTITUTE THE PATH WITH YOUR OWN
setwd("/Users/barba/Desktop/ncbi_refseq_genome_statistics")

### print your current working 
getwd()

### download a summary of current NCBI RefSeq genome assemblies
system("wget https://ftp.ncbi.nlm.nih.gov/genomes/ASSEMBLY_REPORTS/assembly_summary_refseq.txt")
system("wget ftp://ftp.ncbi.nlm.nih.gov/genomes/README_assembly_summary.txt")

### read the file to edit the table
lines <- readLines("assembly_summary_refseq.txt")

### remove the '#' symbol
cleaned_lines <- gsub("#", "", lines)

### convert cleaned lines to a data frame, skip first line, and use quote = "" to avoid issues with unmatched quotes
g_data <- read.table(text = cleaned_lines, sep = "\t", skip = 1, header = TRUE, fill = TRUE, quote = "")

### export the edited data frame to a new file
write.table(g_data, "assembly_summary_refseq_cleaned.txt", sep = "\t", row.names = FALSE, quote = FALSE)

### count number of columns (variables) and rows (observations=genomes)
nrow(g_data)
ncol(g_data)

### count number of genemoes for each major lineage
genome_counts <- table(g_data$group)

### display the result
print(genome_counts)

### summary statistics of gc percent
summary(g_data$gc_percent)

### statistical messures of gc percent
mean(g_data$gc_percent)
median(g_data$gc_percent)
min(g_data$gc_percent)
max(g_data$gc_percent)

############################################
##### create a histogram of gc content #####
############################################

hist(g_data$gc_percent, main="GC content", col="red3")

### add x- and y-axis labels
hist(g_data$gc_percent, main="GC content", col="red3", xlab="GC percent", ylab="Count")

##### create a histogram of gc content usng ggplot2 #####
ggplot(g_data, aes(x = gc_percent)) +
  geom_histogram(fill = "red3") +
  labs(title = "GC content", x = "GC percent", y = "Count")

###########################################
##### create a barplot of genome size #####
###########################################

### create the bar plot
barplot(g_data$genome_size, names.arg=g_data$organism, main="Genome size", xlab="Organism", ylab="Base pairs", cex.names=0.7, cex.axis=0.7, col="purple3")

### sort genome sizes by group
g_data_sorted <- g_data[order(g_data$group,decreasing = FALSE), ]

### display genome counts per group
print(genome_counts)

### create the bar plot sorting genome sizes by group
barplot(g_data_sorted$genome_size, names.arg = g_data_sorted$organism, main = "Genome size", xlab = "Organism", ylab = "Base pairs", cex.names = 0.7, cex.axis = 0.7, col="purple3")

### sort genome sizes in decreasing order 
g_data <- g_data[order(g_data$genome_size, decreasing = TRUE), ]

### create the bar plot sorting genome sizes in decreasing order 
barplot(g_data$genome_size, names.arg=g_data$organism, main="Genome size", xlab="Organism", ylab="Base pairs", cex.names=0.7, cex.axis=0.7, col="purple3")

### create the bar plot for the five largest genomes
barplot(g_data$genome_size[1:5], names.arg=g_data$organism[1:5], main="Genome size", xlab="Organism", ylab="Base pairs", cex.names=0.7, cex.axis=0.7, col="purple3")

### create the bar plot for the five samllest genomes
barplot(g_data$genome_size[554590:554594], names.arg=g_data$organism[554590:554594], main="Genome size", xlab="Organism", ylab="Base pairs", cex.names=0.7, cex.axis=0.7, col="purple3")

### create the barplot of the five largest genomes using ggplot2
ggplot(g_data[1:5, ], aes(x = reorder(organism_name, -genome_size), y = genome_size)) +
  geom_col(fill = "purple3") +
  labs(title = "Genome size", x = "Organism", y = "Base pairs") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

### create the barplot of the five smallest genomes using ggplot2
ggplot(g_data[554590:554594, ], aes(x = reorder(organism_name, -genome_size), y = genome_size)) +
  geom_col(fill = "purple3") +
  labs(title = "Genome size", x = "Organism", y = "Base pairs") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

##################################################################
##### create a stacked barplot of coding and non-coding genes ####
##################################################################

### convert columns to numeric
g_data$protein_coding_gene_count <- as.numeric(as.character(g_data$protein_coding_gene_count))
g_data$non_coding_gene_count <- as.numeric(as.character(g_data$non_coding_gene_count))

### remove rows with NA values
g_data_clean <- na.omit(g_data)

### sort by oding gene count
g_data_clean <- g_data_clean[order(g_data_clean$protein_coding_gene_count, decreasing = TRUE), ]

### create a data matrix for the barplot
data_matrix <- rbind(g_data_clean$non_coding_gene_count, g_data_clean$protein_coding_gene_count)

### create the stacked barplot
### NOTE: THIS PLOT MAY HAVE ISSUES WHEN DISPLAYING OR RENDERING, YOU CAN SKIP THIS ONE
#barplot(data_matrix, col = c("red3", "blue3"), beside = FALSE, legend.text = c("Non-coding genes", "Protein-coding genes"), main = "Number of protein-coding and non-coding genes per organism", names.arg = g_data_clean$organism, xlab = "organism", ylab = "genes", cex.names = 0.7,  cex.axis = 0.7)

### select the first 1000 organisms
g_data_subset <- g_data_clean[1:100, ]

### create a data matrix for the barplot
data_matrix <- rbind(g_data_subset$non_coding_gene_count, g_data_subset$protein_coding_gene_count)

### create the stacked barplot for the first 1000 organisms
barplot(data_matrix, col = c("red3", "blue3"), beside = FALSE, legend.text = c("Non-coding genes", "Protein-coding genes"), main = "Number of protein-coding and non-coding genes per organism", names.arg = g_data_subset$organism, xlab = "organism", ylab = "genes", cex.names = 0.7,  cex.axis = 0.7)

### select the first five organisms
g_data_subset <- g_data_clean[1:5, ]

### create a data matrix for the barplot
data_matrix <- rbind(g_data_subset$non_coding_gene_count, g_data_subset$protein_coding_gene_count)

### create the stacked barplot for the first five organisms
barplot(data_matrix, col = c("red3", "blue3"), beside = FALSE, legend.text = c("Non-coding genes", "Protein-coding genes"), main = "Number of protein-coding and non-coding genes per organism", names.arg = g_data_subset$organism, xlab = "organism", ylab = "genes", cex.names = 0.7,  cex.axis = 0.7)

### select the last five organisms
g_data_subset <- g_data_clean[553689:553694, ]

### create a data matrix for the barplot
data_matrix <- rbind(g_data_subset$non_coding_gene_count, g_data_subset$protein_coding_gene_count)

### create the stacked barplot for last five organisms
barplot(data_matrix, col = c("red3", "blue3"), beside = FALSE, legend.text = c("Non-coding genes", "Protein-coding genes"), main = "Number of protein-coding and non-coding genes per organism", names.arg = g_data_subset$organism, xlab = "organism", ylab = "genes", cex.names = 0.7,  cex.axis = 0.7)

### select the last five organisms
g_data_subset <- g_data_clean[553689:553694, ]

### create a data matrix for the barplot
data_matrix <- rbind(g_data_subset$non_coding_gene_count, g_data_subset$protein_coding_gene_count)

### create the stacked barplot for last five organisms
barplot(data_matrix, col = c("red3", "blue3"), beside = FALSE, legend.text = c("Non-coding genes", "Protein-coding genes"), main = "Number of protein-coding and non-coding genes per organism", names.arg = g_data_subset$organism, xlab = "organism", ylab = "genes", cex.names = 0.7,  cex.axis = 0.7)

### select the 100 five organisms
g_data_subset <- g_data_clean[553595:553694, ]

### create a data matrix for the barplot
data_matrix <- rbind(g_data_subset$non_coding_gene_count, g_data_subset$protein_coding_gene_count)

### create the stacked barplot for last 100 organisms
barplot(data_matrix, col = c("red3", "blue3"), beside = FALSE, legend.text = c("Non-coding genes", "Protein-coding genes"), main = "Number of protein-coding and non-coding genes per organism", names.arg = g_data_subset$organism, xlab = "organism", ylab = "genes", cex.names = 0.7,  cex.axis = 0.7)

###################################################################
##### create a scatterplot of genome size and number of genes #####
###################################################################

### clean the data to remove NA values
cleaned_df <- na.omit(data.frame(genome_size = as.numeric(g_data$genome_size), total_gene_count = as.numeric(g_data$total_gene_count)))

### create the scatterplot 
plot(cleaned_df$genome_size, cleaned_df$total_gene_count, main = "Genome Size vs Number of Genes", xlab = "Genome Size (base pairs)", ylab = "Total Gene Count")
abline(lm(cleaned_df$total_gene_count ~ cleaned_df$genome_size + 0), col="blue3")

### compute correlation
cor(cleaned_df$total_gene_count, cleaned_df$genome_size, method = c("pearson"))

### compute liniear regresion through the origin
fit <- lm(cleaned_df$total_gene_count ~ cleaned_df$genome_size + 0)
fit
summary(fit)

### create the scatterplot using ggplot2 
ggplot(cleaned_df, aes(x = genome_size, y = total_gene_count)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, color = "blue") +
  labs(title = "Genome Size vs Number of Genes",
       x = "Genome Size (base pairs)", 
       y = "Total Gene Count") +
  theme_minimal()

#######################################################
##### create a boxplot of plant and fungi genomes #####
#######################################################

### sort table by group
sorted_table <- g_data[order(g_data$group), ]

### collect plant geneome size
rf1 <- (genome_size=c(sorted_table$genome_size[381746:381931]))

### collect fungi genemoe size
rf2 <- (genome_size=c(sorted_table$genome_size[380685:381316]))

### create a boxplot
require(vioplot)
boxplot(rf1, rf2, names = c("plant", "fungi"), ylab = "genome size (bp)", main = "Plant and fungi genome size")

### create a data frame from rf1 and rf2
box_data <- data.frame(
  genome_size = c(rf1, rf2),
  group = c(rep("plant", length(rf1)),
            rep("fungi", length(rf2)))
)

### create the boxplot using ggplot2
ggplot(box_data, aes(x = group, y = genome_size)) +
  geom_boxplot() +
  labs(
    title = "Plant and fungi genome size",
    x = "",
    y = "Genome size (bp)"
  )

############################################################################################################
##### create a density plot of percentage difference between non-coding and protein-coding gene counts #####
############################################################################################################

### create new dataframe and remove rows conatinng missing values NAs
cleaned_df2 <- na.omit(data.frame(protein_coding_gene_count = g_data$protein_coding_gene_count, non_coding_gene_count = g_data$non_coding_gene_count))

### extract non-coding and protein-coding gene counts
nc <- cleaned_df2$non_coding_gene_count
pc <- cleaned_df2$protein_coding_gene_count

### ensure both vectors are numeric
nc <- as.numeric(nc)
pc <- as.numeric(pc)

### calculate delta_genes as a percentage difference
delta_genes <- ((pc-nc)/nc)*100

### check for NAs in delta_genes after calculation
cat("Number of NAs in delta_genes before cleaning:", sum(is.na(delta_genes)), "\n")

### remove NA values from delta_genes
delta_genes <- na.omit(delta_genes)

### check for NAs again after removal
cat("Number of NAs in delta_genes after cleaning:", sum(is.na(delta_genes)), "\n")

### calculate density of delta_genes
d1 <- density(delta_genes)

### plot the density
plot(d1, main = "Protein-coding and non-coding gene percent difference", xlab = "Percent difference", ylab = "Density", xlim=c(0, 100000), lwd=2 , col="red3")
abline(v = median(delta_genes, na.rm = TRUE), lwd = 2, lty = 2)

### plot the density using ggplot2 
ggplot(data.frame(delta_genes), aes(x = delta_genes)) +
  geom_density(linewidth = 1, color = "red3") +
  geom_vline(xintercept = median(delta_genes, na.rm = TRUE),
             linewidth = 1, linetype = 2) +
  labs(
    title = "Protein-coding and non-coding gene percent difference",
    x = "Percent difference",
    y = "Density"
  ) +
  xlim(0, 100000)

######################################
##### part 02 ########################
######################################
######################################
##### Phylogenomic data analysis #####
######################################

### clear workspace
rm(list=ls())

### ensure the necessary packages are loaded
library(ape)
library(phytools)
library(dendextend)
library(phangorn)
library(ggplot2)

### create a new directory 'ncbi_refseq_genome_statistics'
### NOTE: SUBSTITUTE THE PATH WITH YOUR OWN
dir.create("/Users/barba/Desktop/canid_phylo_analysis")

### set working directory
### NOTE: SUBSTITUTE THE PATH WITH YOUR OWN
setwd("/Users/barba/Desktop/canid_phylo_analysis")

### download a fasta msa of 44 canid mt genomes
system("wget https://raw.githubusercontent.com/josebarbamontoya/fordham_bioinformatics/main/class_09/44canid_mt_genomes.fasta")

### read fasta msa
aln <- read.FASTA("/Users/barba/Desktop/canid_phylo_analysis/44canid_mt_genomes.fasta", type ="DNA")

################################################
##### construct a tree using the nj method #####
################################################

### calculate distance matrix
dist_matrix <- dist.dna(aln, model = "JC69")

### construct a tree using the nj method
nj_tree <- nj(dist_matrix)

### ladderize tree
nj_tree <- ladderize(nj_tree, right = FALSE)

### plot tree
plot(nj_tree, main = "Neighbor-joining tree")

### show tree node labels
nodelabels()

### show tree branch labels
edgelabels()

### save newick tree
write.tree(nj_tree, file = "nj_tree.nwk")

###############################################
##### construct a maximum likelihood tree #####
###############################################

### create phydat object
phy_data <- phyDat(aln, type = "DNA")
fit <- pml(nj_tree, data = phy_data)

### optimize tree
fit <- optim.pml(fit, model = "GTR", optGamma = TRUE)

### plot the ML tree
ml_tree <- fit$tree
plot(ml_tree, main = "Maximum likelihood tree")
nodelabels()
edgelabels()

### save newick tree
write.tree(ml_tree, file = "ml_tree.nwk")

#####################################################
##### comparephylo and robinson-foulds distance #####
#####################################################

### order trees 
a <- read.tree(file = "nj_tree.nwk")
b <- read.tree(file = "ml_tree.nwk")
a <- root(a, outgroup=c("GF_GrayFox_Vermont"), resolve.root=TRUE)
b <- root(b, outgroup=c("GF_GrayFox_Vermont"), resolve.root=TRUE)
a <- ladderize(a, right = FALSE)
b <- ladderize(b, right = FALSE)

### plot ordered trees 
plot(a, main = "Neighbor-joining tree (sorted)")
plot(b, main = "Maximum likelihood tree (sorted)")

### compare order trees 
comparePhylo(a, b, plot = TRUE, force.rooted = TRUE, use.edge.length = TRUE, location = NA)

### compute rf distance
trees <- c(a,b)
multiRF(trees)

### compute normalized rf distance = plain_RF/(2*(n-3))
nrf <- 0/(2*(44-3))
nrf

##### create a tanglegram
a <- read.tree(file = "nj_tree.nwk")
b <- read.tree(file = "ml_tree.nwk")
a <- root(a, outgroup=c("GF_GrayFox_Vermont"), resolve.root=TRUE)
b <- root(b, outgroup=c("GF_GrayFox_Vermont"), resolve.root=TRUE)
a <- force.ultrametric(a, method=c("extend"))
b <- force.ultrametric(b, method=c("extend"))
a <- as.dendrogram(a)
b <- as.dendrogram(b)
dend1 <- ladderize(a, right = FALSE)
dend2 <- ladderize(b, right = FALSE)
dl <- dendlist(dend1,dend2)
dl %>% untangle %>% tanglegram(common_subtrees_color_lines=FALSE, lwd=1, highlight_distinct_edges=TRUE, highlight_branches_lwd=FALSE, margin_inner=15, axes=FALSE, lab.cex=.75)

### reset the plot layout after the tanglegram
par(mfrow = c(1, 1))

###################################################
##### scatterplot of nj and ml branch lengths #####
###################################################

### make branch length dataframes
nj_tree <- ladderize(nj_tree, right = FALSE)
ml_tree <- ladderize(ml_tree, right = FALSE)
nj_bl <- nj_tree$edge.length
ml_bl <- ml_tree$edge.length

### create the scatterplot
plot(nj_bl, ml_bl, main = "NJ vs. ML tree branch lengths", xlab = "NJ branch lengths", ylab = "ML branch lengths")
abline(lm(ml_bl ~ nj_bl + 0), col="blue3")

### compute correlation
cor(ml_bl, nj_bl, method = c("pearson"))

### compute liniear regresion through the origin
fit <- lm(ml_bl ~ nj_bl + 0)
fit
summary(fit)

### create the scatterplot in ggplot2
ggplot(data.frame(nj_bl, ml_bl), aes(x = nj_bl, y = ml_bl)) +
  geom_point() +
  geom_smooth(method = "lm", formula = y ~ x + 0, se = FALSE, color = "blue3") +
  labs(
    title = "NJ vs. ML tree branch lengths",
    x = "NJ branch lengths",
    y = "ML branch lengths"
  )

