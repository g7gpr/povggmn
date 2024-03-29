#!/bin/bash

#Script to start rsync if it is not already running
echo Camera $1
echo Username $2

#use ps to discover if rsync is running in this user account
rsyncrunning=$(ps -x | grep rsync | grep $2 | wc -l)
echo Number of rsync running lines $rsyncrunning
if [ $rsyncrunning -eq "0" ];
then
echo rsync is not running - start it
#nohup rsync -av -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"   --partial-dir=partial/ ~/RMS_data/ArchivedFiles/*.bz2 $(whoami)@192.168.1.241:files/incoming  &
nohup rsync --password-file=/home/$2/.passfile  -avzh  --partial-dir=.partial ~/RMS_data/ArchivedFiles/*.bz2 rsync://$1@rvrgm.asuscomm.com:12000/$1 &
logger -s -t rsync started
else
echo rsync is running - do nothing
fi

