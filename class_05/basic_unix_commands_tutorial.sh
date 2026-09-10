#!/bin/bash

##########################################
##### Basic Unix Commands Tutorial #######
##### Jose Barba #########################
##########################################

# 0. Open a new session in either the Terminal app on your Mac or a terminal on your UNIX/UNIX-like OS

# 0-optional. Connect to the remote server using SSH:
ssh [username]@erdos.dsm.fordham.edu

# 1. show the current directory
pwd

# 2. list files and directories (including hidden files)
ls -la

# 3. change to home directory
cd ~

# 4. create a new directory called 'test_directory'
mkdir test_directory

# 5. change to 'test_directory'
cd test_directory

# 6. create an empty .txt file
touch f01.txt

# 7. write a "hello world :)" message to f01.txt
echo "hello world :)" > f01.txt

# 8. display f01.txt content
cat f01.txt

# 9. list all files
ls -la

# 10. get help on the 'ls' command and quit
man ls 
# press q to quit

# 11. copy file 'f01.txt'
cp f01.txt f01_copy.txt

# 12. rename 'f01_copy.txt'
mv f01_copy.txt f01_to_delete.txt

# 13. remove 'f01_to_delete.txt'
rm f01_to_delete.txt

# 14. create file 'f02.txt' using nano
nano f02.txt

# 15. within nano, type:
mammals birds
bat eagle
bear falcon
dolphin hawk
elephant owl
giraffe parrot
human penguin
kangaroo raven
lion sparrow
tiger swallow
whale woodpecker
# to write out file, press ^O, then press return
# to exit nano, press ^X

# 16. display the content of 'f02.txt'
cat f02.txt

# 17. display the top two lines in 'f02.txt' 
head -n2 f02.txt

# 18. display the bottom two lines in 'f02.txt' 
tail -n2 f02.txt

# 19. search for the word 'lion' in 'f02.txt' using grep
grep "lion" f02.txt

# 20. extract the first column of 'f02.txt' using awk (assuming data is space-separated)
awk '{print $1}' f02.txt

# 21. find file 'f02.txt' in the current directory and subdirectories
find . -name "f02.txt"

# 22. change back to the home directory
cd ~

# 23. remove the 'test_directory' and its contents
rm -r test_directory
