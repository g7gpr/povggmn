#!/bin/bash

#This script does all the final routines per camera. This produces a trackstack of the nights meteor detections

#Process arguments

#find the latest directories
username=$(pwd | pwd | cut -d '/' -f3 )
echo Username is $username
latestdirectory=`ls /home/$username/RMS_data/CapturedFiles | tail  -n1`
latestdirectory=/home/$username/RMS_data/CapturedFiles/$latestdirectory
latestarchiveddirectory=`ls /home/$username/RMS_data/ArchivedFiles | tail  -n2 | head -n1`
latestarchiveddirectory=/home/$username/RMS_data/ArchivedFiles/$latestarchiveddirectory

echo Latest directory is $latestdirectory
echo Latest archived directory is $latestarchiveddirectory

source /home/$username/vRMS/bin/activate
cd /home/$username/source/RMS

echo "Starting TrackStack"
python -m Utils.TrackStack $latestdirectory 
echo Trackstack from $username was formed from files in $latestdirectory.  | mail -s "$username trackstack" g7gpr@outlook.com davidrollinson@hotmail.com -A $latestdirectory/*_track*

