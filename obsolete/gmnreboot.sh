#!/bin/bash
#This script can either be called by any users cron, probably gmn on a regular basis, or from the shutdown function

echo Number of pending shutdowncalls is $(ls /home/gmn/shutdowncalls | wc -l)
if [ $(ls /home/gmn/shutdowncalls | wc -l) -gt 5 ]
then
 echo Remove all from the running cameras directory
 rm -f /home/gmn/camerasrunning/*
 echo Ready for reboot
 rm -f /home/gmn/shutdowncalls/*
 echo "Wiped directory"
 sleep 180
 echo "Calling reboot"
  sudo reboot now
fi
