#!/bin/bash

#Script to start rsync if it is not already running

rsyncrunning=$(ps -x | grep rsync | grep $(whoami) | wc -l)
echo Number of rsync running lines $rsyncrunning
if [ $rsyncrunning -eq "0" ];
then
echo rsync is not running
nohup sshpass -p $1 rsync -a --partial-dir=partial/ ~/RMS_data/ArchivedFiles/*.bz2 rsync://$(whoami)@192.168.1.230:12000/$(whoami) &
logger -s -t rsync started
else
echo rsync is running
fi

