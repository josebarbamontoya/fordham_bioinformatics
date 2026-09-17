#!/bin/bash

###########################################
##### For and While Loop Examples #########
##### Jose Barba ##########################
###########################################

#############################
##### for loop ##############
#############################

### for loop: iterate over a list of values
for var in item1 item2 item3
do
    command $var
done

### example 1: print each filename in the current directory
for file in *
do
    echo $file
done

### example 2: change the extension of all .txt files to .sh
for file in *.txt
do
    mv "$file" "${file%.txt}.sh"
done

###############################
##### while loop ##############
###############################

### while loop: execute as long as a condition is true
while [ condition ]
do
    command
done

### example 1: count down from 5
count=5

while [ $count -gt 0 ]
do
    echo $count
    count=$((count - 1))
done

### example 2: count fasta sequences in a fasta file
count=0

while read line
do
    if [[ $line == ">"* ]]
    then
        count=$((count + 1))
    fi
done < sequences.fasta

echo $count
