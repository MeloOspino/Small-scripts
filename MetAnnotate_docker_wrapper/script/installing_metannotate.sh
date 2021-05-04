#!/bin/bash
# Input variable
dir_path=$1 #PATH where to install MetAnnotate

# Install the script (only need to do this once)
mkdir $1
git clone -b develop https://github.com/MetAnnotate/MetAnnotate.git
cd MetAnnotate
chmod 755 enter-metannotate
cp enter-metannotate $1
cd $1
rm -rf MetAnnotate 
# Enter the Docker container using the script
./enter-metannotate # to see informative help file that goes into more detail than presented here
echo ------------If you see informative help file that goes into more detail of metannotate, it is well installed.---------------
