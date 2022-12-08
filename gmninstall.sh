#!/bin/bash

#This script install RMS into a single username

#Change to the home directory
cd ~


#Clean up before we start
rm install.sh
rm opencv4_install.sh
rm -rf source

#get the files
#wget https://gist.githubusercontent.com/edharman/24f2d8a9a6c475057e68b2f490da9632/raw/3e7d2f18c45aba04ab015ba46d17f242ece2e4e8/install.sh 
#wget https://gist.githubusercontent.com/edharman/dc8dc37d5f9216c97c345c6b0abab251/raw/4a11cfbc508eed48ce6143e2b4c50850d393bd7f/opencv4_install.sh 
wget https://gist.githubusercontent.com/edharman/24f2d8a9a6c475057e68b2f490da9632/raw/eafd0120064641b67deeb9bde133baf0b2a12970/install.sh
wget https://gist.githubusercontent.com/edharman/96ebcd7809c3f4b85e72781145d03e0f/raw/2d936f2b52e1b7a3ec4f77d52d425c6e9c4050cf/opencv4_install.sh 


#Make them executable
chmod +x *.sh

#install curl - this is needed by istrastream but does not always get installed
sudo apt-get install curl -y

sudo apt-get install sshpass -y

#install mutt
sudo apt-get install ssmtp mutt -y

#install rsync
sudo apt-get install rsync -y

#Do the installation
./install.sh


#Clean up
rm install.sh
rm opencv4_install.sh

#Make the outbox directory
sudo mkdir /home/gmn/outbox
sudo chmod a=rwx /home/gmn/outbox
/home/gmn/scripts/povggmn/gmninitstates.sh

