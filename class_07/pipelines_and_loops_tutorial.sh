#!/bin/bash

###########################################
##### Shell Pipelines and Loops ###########
##### Jose Barba ##########################
###########################################

### NOTE: replace 'jbarba' with your erdos username wherever it appears. Use the correect path (/u/erdos/students/username/...).

###########################
##### part 01 #############
##### shell pipelines #####
###########################

### connect to the remote server erdos using ssh:
ssh jbarba@erdos.dsm.fordham.edu

### change to home directory
cd ~

### download mammal_data_analysis.zip file from github
wget https://raw.githubusercontent.com/josebarbamontoya/fordham_bioinformatics/main/class_07/mammal_data_analysis.zip

### uncompress `mammal_data_analysis.zip` using `unzip`
unzip mammal_data_analysis.zip

### change to `mammal_data_analysis` directory
cd mammal_data_analysis

### list alignemtns and count the number of alignments
ls *.fas | wc -l

### count the total number of sequences for each FASTA file 
grep -c "^>" *.fas | sed 's/:/ - /'

### check if all the alignments contain the outgroup ornithorhynchus_anatinus
grep "ornithorhynchus_anatinus" *.fas | nl

### search for repetitive segments in all the alignments
grep "AAAAAAAA" *.fas  | nl

### compute the GC content of each .fas file and print the result
ls *.fas | xargs -I {} sh -c 'echo "{}: "; grep -v "^>" "{}" | awk "{gc+=gsub(/[GCgc]/,\"\"); total+=length(\$0)} END {if (total > 0) print (gc/total)*100 \"%\"; else print \"0%\"}"'

###############################
##### part 02 #################
###### for loop exercises #####
###############################

### E1) count the total number of sequences for 5 selected fasta files within mammal_data_analysis directory
for file in m2778_subsampled_gb.fas m3085_subsampled_gb.fas m4281_subsampled_gb.fas m11337_subsampled_gb.fas m14339_subsampled_gb.fas
do
  count=$(grep -c "^>" "$file")
  echo "$file: $count sequences"
done

### E2) count the total number of sequences for each fasta file within mammal_data_analysis directory
for file in *.fas; do
  count=$(grep -c "^>" "$file")
  echo "$file: $count sequences"
done

### E3) iqtree loop mammal_data_analysis
### change to home directory
cd ~
### change iqtree permission 
chmod 777 mammal_data_analysis/iqtree2

### copy mammal_data_analysis into two new directories
cp -r mammal_data_analysis mammal_data_analysis_gtr
cp -r mammal_data_analysis mammal_data_analysis_hky

cd /u/erdos/jbarba/mammal_data_analysis_gtr
for file in /u/erdos/jbarba/mammal_data_analysis_gtr/*.fas
do
  # iqtree operation using $file
  /u/erdos/jbarba/mammal_data_analysis_gtr/iqtree2 -s $file -m GTR+G5 -nt 2
done

cd /u/erdos/jbarba/mammal_data_analysis_hky
for file in /u/erdos/jbarba/mammal_data_analysis_hky/*.fas
do
  # iqtree operation using $file
  /u/erdos/jbarba/mammal_data_analysis_hky/iqtree2 -s $file -m HKY+G5 -nt 2
done

### extract likelihood from iqtree info files
cd /u/erdos/jbarba/mammal_data_analysis_gtr
grep "BEST SCORE FOUND :" *.log > iqtree_tree_likelihoods_gtr.txt

### extract likelihood from iqtree info files
cd /u/erdos/jbarba/mammal_data_analysis_hky
grep "BEST SCORE FOUND :" *.log > iqtree_tree_likelihoods_hky.txt

### compare tree likelihoods from diffrent models
### gtr likelihoods
cat /u/erdos/jbarba/mammal_data_analysis_gtr/iqtree_tree_likelihoods_gtr.txt
### gtr likelihood average
awk '{sum += $5; n++} END {print sum/n}' /u/erdos/jbarba/mammal_data_analysis_gtr/iqtree_tree_likelihoods_gtr.txt
### hky likelihoods
cat /u/erdos/jbarba/mammal_data_analysis_hky/iqtree_tree_likelihoods_hky.txt
### hky likelihood average
awk '{sum += $5; n++} END {print sum/n}' /u/erdos/jbarba/mammal_data_analysis_hky/iqtree_tree_likelihoods_hky.txt

### E4) find a list of strings, loop through files in a directory, and create a prescence list

### First, create a script with the loop code below like `find_string_loop_files_make_presence_list.sh`

#!/bin/bash

### define the three words you want to search for
word1="notamacropus_eugenii"
word2="sarcophilus_harrisii"
word3="monodelphis_domestica"

### set the directory where your files are located
directory="/u/erdos/jbarba/mammal_data_analysis"

### create an empty file to store the list of matching files
output_file="matching_files.txt"
> "$output_file"

### loop through each file in the directory
for file in "$directory"/*; do
    # check if the file contains any of the three words
    if grep -qE "$word1|$word2|$word3" "$file"; then
        # if it contains any of the words, append the filename to the output file
        echo "$file" >> "$output_file"
    fi
done

### print the list of matching files
cat "$output_file"

#################################
##### part 03 ###################
###### while loop exercises #####
#################################

### E1) print sequence headers
while IFS= read -r line
do
    if [[ $line == ">"* ]]; then
        echo "$line"  # print the header
    fi
done < m2778_subsampled_gb.fas

### E2) count the number of bases in each sequence (ignoring headers)
sequence=""
while IFS= read -r line
do
    if [[ $line == ">"* ]]; then
        if [[ -n $sequence ]]; then
            length=${#sequence}
            echo "total sequence length: $length" >> output.txt
            sequence=""  # reset sequence for the next one
        fi
        echo "$line" >> output.txt  # print the header to output.txt
    else
        sequence+="$line"  # concatenate sequence lines
    fi
done < m2778_subsampled_gb.fas

### process the last sequence in the file
if [[ -n $sequence ]]; then
    length=${#sequence}
    echo "total sequence length: $length" >> output.txt
fi

#########################################
##### part 04 ###########################
##### combining loops and pipelines #####
#########################################

### E1) search for occurrences of "homo_sapiens" in all .fas files
cd /u/erdos/jbarba/mammal_data_analysis

for file in *.fas; do
    count=$(grep "homo_sapiens" "$file" | wc -l)
    echo "$file: $count"
done

### E2) extract ornithorhynchus_anatinus sequence from all the alignments
awk 'BEGIN { FS="\n"; RS=">"; ORS="" } NR > 1 { header = $1; seq = ""; for (i = 2; i <= NF; i++) { seq = seq $i; } print ">" header "\n" seq "\n" FILENAME; }' *.fas | sed 's/ //g' | grep -A 1 'ornithorhynchus_anatinus'

### E3) calculate GC Content for each sequence
sequence=""
while IFS= read -r line
do
    if [[ $line == ">"* ]]; then
        if [[ -n $sequence ]]; then
            gc_count=$(echo "$sequence" | grep -o "[GCgc]" | wc -l)  # count Gs and Cs
            total_count=${#sequence}  # get total number of bases
            gc_percentage=$(echo "scale=2; ($gc_count/$total_count)*100" | bc)
            echo "GC Content: $gc_percentage%" >> gc_output.txt
            sequence=""  # reset sequence for the next one
        fi
        echo "$line" >> gc_output.txt  # print the header to output.txt
    else
        sequence+="$line"  # append sequence lines
    fi
done < m2778_subsampled_gb.fas

# for the last sequence in the file
if [[ -n $sequence ]]; then
    gc_count=$(echo "$sequence" | grep -o "[GCgc]" | wc -l)
    total_count=${#sequence}
    gc_percentage=$(echo "scale=2; ($gc_count/$total_count)*100" | bc)
    echo "GC Content: $gc_percentage%" >> gc_output.txt
fi
