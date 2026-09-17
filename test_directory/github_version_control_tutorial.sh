#!/bin/bash

###########################################
##### GitHub Version Control Tutorial #####
##### Jose Barba ##########################
###########################################

### FYI: version control is a system that tracks changes to files over time. Git is a useful version control system, and GitHub is a cloud-based hosting platform for Git repositories.

### OPTIONAL: Use the erdos server or your laptop. I recommend using your laptop.
### if using erdos
ssh username@erdos.dsm.fordham.edu

##### part 01 #####
##### set ssh for github authentication #####

### a. generate an ssh key (if you do not have one)
### 1. open a terminal and run
cd ~
ssh-keygen -t rsa -b 4096
### 2. press enter to accept the default file location, and optionally provide a passphrase for added security

### b. add the ssh Key to your github account
### 1. copy the ssh key to your clipboard
cat ~/.ssh/id_rsa.pub
### 2. go to github ssh and gpg keys or navigate through: settings > ssh and gpg keys > new ssh key
### 3. paste the ssh key into the text box and give it a descriptive title
### 4. click add ssh key

##### part 02 #####
##### set up git #####

### 1. check if git is already installed
git --version
### 2. if git is not installed, install it. First, install homebrew if you do not already have it
### 3. check if homebrew is installed
which brew
### 4. if brew is not installed, install homebrew 
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
### 5. install git using brew
brew install git
### 6. (optional) after installation, configure git with your username and email (which will appear in your commits)
git config --global user.name "your name"
git config --global user.email "your.email@example.com"

##### part 03 #####
##### create a new repository on github #####

### 1. go to your github homepage and click the + icon in the top right corner
### 2. choose new repository
### 3. give your repository a name, description (optional), and choose whether it should be public or private
### 4. click create repository

##### part 04 #####
##### initialize a local git repository #####

### create a new project directory
cd ~ 
mkdir test_repo_f
cd test_repo_f
echo "# test repo f" > README.md

### initialize a new git repository
git init

### add `README.md` to the staging area
git add README.md

### or add all files within the project directory to the staging area
git add .

### create a commit with a descriptive message:
git commit -m "first commit"

### rename the current branch to main
git branch -M main

### link your local repository to the one you created on github
### NOTE: substitute your github username and repository name with your own
git remote add origin https://github.com/josebarbamontoya/test_repo_f.git

### change the git remote url to use ssh instead of https
### NOTE: substitute your github username and repository name with your own
git remote set-url origin git@github.com:josebarbamontoya/test_repo_f.git

### send your committed changes to github 
git push -u origin main

##### part 05 #####
##### make changes, push updates, and clone an existing repository, viewing history #####

### check the status of files
git status

### create a new file to commit
echo "# test file" > test_file.txt

### stage the files you have modified
git add test_file.txt

### commit the changes 
git commit -m "second commit"

### push the changes to github
git push

### clone an existing repository from github to your local machine
git clone --recursive https://github.com/josebarbamontoya/test_repo_f

### check the history of commits
git log

### see a more compact, single-line view of commits
git log --oneline

##### part 06#####
##### branching, merging, pulling changes from github, and resolving merge conflicts #####

##### branching and merging #####
### a. create a new branch
### branches allow you to work on different versions of a project simultaneously 
### to create and switch to a new branch
git checkout -b new-feature

### b. switch branches
### to switch back to the main branch
git checkout main

### c. merge branches
### once you finish working on a feature, you can merge the changes into the main branch
### first, switch to the main branch
git checkout main

### then merge your changes
git merge new-feature

##### pulling changes from gitHub #####
### if you are working with a team, others may push changes to the repository
### to get those changes use
git pull origin main
### this will update your local repository with any changes from github

##### resolving merge conflicts #####
### when working in a team, conflicts may occur if multiple people edit the same file. 
### git will prompt you to resolve these conflicts manually:
### 1. open the conflicted file and decide how to combine the changes
### 2. once resolved, mark it as resolved by adding it again
git add test_file.txt
### 3. commit the merge
git commit -m "resolved merge conflict"
### 4. push the changes to github
git push
