#!/bin/bash

#Call this file from the users crontab every ten minutes


cd ~											#change to home directory
sleep 10										#wait for a while
if test -f /home/gmn/camerasrunning/$(whoami)						#is this camera already running
then
echo $(whoami) already running								#yes, do nothing
else
echo Start $(whoami)									#no, announce that we are starting
touch /home/gmn/camerasrunning/$(whoami)						#add a file to show that this camera has started
/usr/bin/screen -dmS $(whoami) /home/gmn/scripts/povggmn/gmnupdateandrun.sh		#and start
fi
