#!/bin/bash

###########################################
##### SCP and SFTP (Fordham-erdos) ########
##### Jose Barba ##########################
###########################################

### NOTE: replace `username` with your erdos username

##### SCP example #####

### login to erdos server:
ssh username@erdos.dsm.fordham.edu

### students: transfer a directory (my_dir) or a file from erdos server to your computer (home directory):
scp -r username@erdos.dsm.fordham.edu:/u/erdos/students/username/my_dir ~/

### students: transfer a directory (my_dir) or a file from your computer to erdos server:
scp -r my_ dir username@erdos.dsm.fordham.edu:/u/erdos/students/username/

##### SFTP example #####

### start sftp:
sftp username@erdos.dsm.fordham.edu 

### to transfer a directory (my_dir) or a file, within the sftp interface enter:
sftp> get -r my_dir

##############################
##############################
##############################

##### SCP example #####
### login to erdos:
ssh jbarba@erdos.dsm.fordham.edu
### transfer a directory or a file from lamark to erdos server:
scp -r homo_sapiens_genome_sequences jbarba@erdos.dsm.fordham.edu:/u/erdos/jbarba/
### transfer a directory or a file from erdos server to lamarck ###
scp -r jbarba@erdos.dsm.fordham.edu:/u/erdos/jbarba/homo_sapiens_genome_sequences /Users/barba/Desktop
##### SFTP example#####
### start sftp
sftp jbarba@erdos.dsm.fordham.edu 
### to transfer a directory or a file, within the sftp interface enter:
sftp> get -r homo_sapiens_genome_sequences
