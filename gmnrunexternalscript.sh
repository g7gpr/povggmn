#!/bin/bash

#This script calls gmnrunexternalscript with the path to the latest directory and latest archived directory

#Process arguments

#find the latest directories
username=$(whoami)
latestdirectory=`ls /home/$username/RMS_data/CapturedFiles | tail  -n1`
latestdirectory=/home/$username/RMS_data/CapturedFiles/$latestdirectory
latestarchiveddirectory=`ls /home/$username/RMS_data/ArchivedFiles | tail  -n2 | head -n1`
latestarchiveddirectory=/home/$username/RMS_data/ArchivedFiles/$latestarchiveddirectory

echo Latest directory is $latestdirectory
echo Latest archived directory is $latestarchiveddirectory
source ~/vRMS/bin/activate
cd ~/source/RMS
echo "Starting RunExternalScript"
python -m RMS.RunExternalScript $latestdirectory $latestarchiveddirectory


