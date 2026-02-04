#!/bin/bash

#Script to start rsync if it is not already running


#use ps to discover if rsync is running in this user account
rsyncrunning=$(ps -x | grep rsync | grep $(whoami) | wc -l)
whoami_upper="${USER^^}"

echo Number of rsync running lines $rsyncrunning
if [ $rsyncrunning -eq "0" ];
then
echo rsync is not running - start it
rsync --progress -av -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" --bwlimit=1024  --partial-dir=partial/ /home/rms/RMS_data/${whoami_upper}/ArchivedFiles/*_metadata.tar.bz2 192.168.1.241:files/incoming
rsync --progress -av -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" --bwlimit=1024  --partial-dir=partial/ /home/rms/RMS_data/${whoami_upper}/ArchivedFiles/*_imgdata.tar.bz2 192.168.1.241:files/incoming
rsync --progress -av -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" --bwlimit=1024  --partial-dir=partial/ /home/rms/RMS_data/${whoami_upper}/FramesFiles/*.tar 192.168.1.241:files/incoming
logger -s -t rsync started
else
echo rsync is running - do nothing
fi

