#!/bin/bash

#This script goes out to a remote machine and pulls back the files required to do work on platepars
#It starts skyfit on the local machine and when skyfit has finished, it saves the platepars back to the remote machine. 
#It also holds backups of the key files.

#Process arguments

#find the latest directories
username=$(whoami)
latestdirectory=`ls /home/$username/RMS_data/CapturedFiles | tail  -n2 | head -n1`
latestdirectory=/home/$username/RMS_data/CapturedFiles/$latestdirectory
latestarchiveddirectory=`ls /home/$username/RMS_data/ArchivedFiles | tail  -n2 | head -n1`
latestarchiveddirectory=/home/$username/RMS_data/ArchivedFiles/$latestarchiveddirectory

echo Latest directory is $latestdirectory
echo Latest archived directory is $latestarchiveddirectory
source ~/vRMS/bin/activate
cd ~/source/RMS
echo "Starting iStream.sh"
STATION_ID=$(echo $username | tr '[:lower:]' '[:upper:]')
echo STATION_ID = $STATION_ID
echo CAPTURED_DIR_NAME = $latestdirectory
echo ARCHIVED_DIR_NAME = $latestarchiveddirectory
iStream/iStream.sh $STATION_ID $CAPTURED_DIR_NAME $ARCHIVED_DIR_NAME 0.0 0.0 0.0 0.0 0.0 3601


