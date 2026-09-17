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