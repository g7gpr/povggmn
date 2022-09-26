#!/bin/bash
#This script can either be called by any users cron, probably gmn on a regular basis, or from the shutdown function
#It checks that the same number of cameras are in the shutdown calls directory as in the home directory and then reboots the computer

echo Number of pending shutdowncalls is $(ls /home/gmn/shutdowncalls | wc -l)
cameras=`ls /home/ | grep au | wc -l`
echo Number of cameras in home directory is $cameras
if [ $(ls /home/gmn/shutdowncalls | wc -l) -ge $cameras ]
then
 echo Remove all from the running cameras directory
 rm -f /home/gmn/camerasrunning/*
 echo Ready for reboot
 rm -f /home/gmn/shutdowncalls/*
 echo "Wiped directory"
 echo "Waiting 180 seconds"
 sleep 180
 echo "Calling reboot"
  sudo reboot
fi
