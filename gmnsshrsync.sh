#!/bin/bash

#Script to start rsync if it is not already running


#use ps to discover if rsync is running in this user account
rsyncrunning=$(ps -x | grep rsync | grep $(whoami) | wc -l)
echo Number of rsync running lines $rsyncrunning
if [ $rsyncrunning -eq "0" ];
then
echo rsync is not running - start it
nohup rsync -av -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"   --partial-dir=partial/ ~/RMS_data/ArchivedFiles/*.bz2 $(whoami)@192.168.1.230:files/incoming  &
logger -s -t rsync started
else
echo rsync is running - do nothing
fi

