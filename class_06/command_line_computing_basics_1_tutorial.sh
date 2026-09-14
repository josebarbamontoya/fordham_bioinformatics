#!/bin/bash

###########################################
##### Command Line Computing Basics 1 #####
##### Jose Barba ##########################
###########################################

##### part 01 #####
##### edit raw fasta sequence names #####

### change to home directory
cd ~

### download fasta_alignments.zip file from github
wget https://raw.githubusercontent.com/josebarbamontoya/rggs_comparative_genomics_2/main/session_02/fasta_alignments.zip

### uncompress `fasta_alignments.zip` using `unzip`
unzip fasta_alignments.zip

### or uncompress `fasta_alignments.zip` using `tar`
tar -xf fasta_alignments.zip

### change to `fasta_alignments` directory
cd fasta_alignments

### count the number of sequences in each alignment
grep -o ">" uce-203.fasta | wc -l
grep -o ">" uce-1978.fasta | wc -l
grep -o ">" uce-3715.fasta | wc -l

### count the total number of sequences from all fasta files in the directory
cat *.fasta | grep ">" | wc -l

### display the content of 'uce-203.fasta' 
cat uce-203.fasta

### edit sequence names part 01
sed -i ".bak" 's/uce-203_//g' uce-203.fasta
sed -i ".bak" 's/uce-1978_//g' uce-1978.fasta
sed -i ".bak" 's/uce-3715_//g' uce-3715.fasta

### display the top line in 'uce-203.fasta' 
head -n1 uce-203.fasta

### edit sequence names part 02
sed -i ".bak" 's/ |uce-203//g' uce-203.fasta
sed -i ".bak" 's/ |uce-1978//g' uce-1978.fasta
sed -i ".bak" 's/ |uce-3715//g' uce-3715.fasta

### display the top line in 'uce-203.fasta' 
head -n1 uce-203.fasta

### edit sequence names part 03
sed -i ".bak" 's/_R_//g' *.fasta

### display the content of 'uce-203.fasta' 
cat uce-203.fasta

### remove all .bak files
rm *.bak

##### part 02 #####
##### extract information from a csv table #####

### change to home directory
cd ~

### create a directory
mkdir mammal_genome_stats

### change to mammal_genome_stats
cd mammal_genome_stats

### download fasta_alignments.zip file from github
wget https://raw.githubusercontent.com/josebarbamontoya/rggs_comparative_genomics_2/main/session_02/mammal_genome_statistics.csv

### display the content of 'mammal_genome_statistics.csv' 
cat mammal_genome_statistics.csv

### extract specific columns (1st and 4th), assuming the fields are separated by commas:
awk -F',' '{print $1, $4}' mammal_genome_statistics.csv

### extract specific columns (1st and 4th), assuming the fields are separated by commas and create a new csv table:
awk -F',' '{print $1, $4}' mammal_genome_statistics.csv > mammal_chromosomes.csv
sed -i ".bak" 's/ /,/g' mammal_chromosomes.csv

### remove all .bak files
rm *.bak

##### part 03 #####
##### extract lines containing a string #####

### change to home directory
cd ~

### download `raxml_info_files.zip` file from github
wget https://raw.githubusercontent.com/josebarbamontoya/rggs_comparative_genomics_2/main/session_02/raxml_info_files.zip

### uncompress `raxml_info_files.zip` using `tar`
tar -xf raxml_info_files.zip

### change to raxml_info_files directory
cd raxml_info_files 

### extract likelihood from raxml info files
grep "final GAMMA-based Likelihood:" raxml_info_files/RAxML_info.full_aln* > /Users/barba/Desktop/raxml_tree_likelihoods.txt

### display the content of 'raxml_tree_likelihoods.txt' 
cat raxml_tree_likelihoods.txt

### extract specific columns (1st and 5th), assuming the fields are separated by space and create a new csv table:
awk -F' ' '{print $1, $5}' raxml_tree_likelihoods.txt > raxml_tree_likelihoods.csv
sed -i ".bak" 's/ /,/g' raxml_tree_likelihoods.csv

##### part 04 #####
##### combine mcmc posterior samples #####

### change to home directory
cd ~

### download `mcmc_posterior_samples.zip` file from github
wget https://raw.githubusercontent.com/josebarbamontoya/rggs_comparative_genomics_2/main/session_02/mcmc_posterior_samples.zip

### uncompress `mcmc_posterior_samples.zip` using `tar`
tar -xf mcmc_posterior_samples.zip

### change to raxml_info_files directory
cd mcmc_posterior_samples 

### delete headings and burnin samples from four runs
sed -i".bak" '2,1000d' mcmc_01.txt
sed -i".bak" '1,1000d' mcmc_02.txt
sed -i".bak" '1,1000d' mcmc_03.txt
sed -i".bak" '1,1000d' mcmc_04.txt

### concatenate posterior samples
cat mcmc_01.txt mcmc_02.txt mcmc_03.txt mcmc_04.txt > mcmc_all.txt

### or concatenate posterior samples using *
cat *.txt > mcmc_all.txt

### remove all .bak files
rm *.bak

##### part 05 #####
##### rename tree tip labels #####

### change to home directory
cd ~

### create a tree in newick format
echo "((((8,7),6),(5,4)),((3,2),1));" > toy_tree.nwk

### display the content of 'toy_tree.nwk' 
cat toy_tree.nwk

### copy and rename tree
cp toy_tree.nwk toy_tree_edited.nwk

sed -i ".bak" 's/1/sp_a/g' toy_tree_edited.nwk
sed -i ".bak" 's/2/sp_b/g' toy_tree_edited.nwk
sed -i ".bak" 's/3/sp_c/g' toy_tree_edited.nwk
sed -i ".bak" 's/4/sp_d/g' toy_tree_edited.nwk
sed -i ".bak" 's/5/sp_e/g' toy_tree_edited.nwk
sed -i ".bak" 's/6/sp_f/g' toy_tree_edited.nwk
sed -i ".bak" 's/7/sp_g/g' toy_tree_edited.nwk
sed -i ".bak" 's/8/sp_h/g' toy_tree_edited.nwk

### display the content of .nwk files in the directory
cat *.nwk

### remove all .bak files
rm *.bak

##### part 06 #####
##### create and run a shell script #####

### change to home directory
cd ~

### create a directory
mkdir my_script

### change to my_script
cd my_script

### create a shell file (.sh)
echo "cat f01.txt f02.txt f03.txt > my_pets.txt" > my_script.sh

### change all permission for `my_script.sh`
chmod 777 my_script.sh

### create three text files with content
echo "dog" > f01.txt
echo "cat" > f02.txt
echo "hamster" > f03.txt

### edit my_script.sh in nano
nano my_script.sh

### within nano, type in on the first line
#!/bin/bash
# to write out file, press ^O
# to exit nano, press ^X

### run `my_script.sh`
./my_script.sh

### display content in `my_pets.txt`
cat my_pets.txt
