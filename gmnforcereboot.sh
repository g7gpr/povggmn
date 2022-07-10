#!/bin/bash
#this script allows the user to reboot the machine and wipe clean the running cameras directory

echo Remove all from the running cameras directory
rm -f /home/gmn/camerasrunning/*
echo Ready for reboot
rm -f /home/gmn/shutdowncalls/*
echo "Wiped directory"
echo "Calling reboot"
sudo reboot now
