#!/bin/bash

#This script will run a track stack for all the cameras on this system

thiscamera=au000u
for thiscamerapath in /home/gmn/cameras/*
do
thiscamera=`echo $thiscamerapath | cut -d'/' -f5-`
captured=/home/$thiscamera/RMS_data/CapturedFiles/`ls /home/$thiscamera/RMS_data/CapturedFiles/ | tail -n1 | head -n1`
echo $captured
track_stack_date=$(echo $captured | cut -d_ -f3)
commandstring=$commandstring'   '$captured
captured=/home/$thiscamera/RMS_data/CapturedFiles/`ls /home/$thiscamera/RMS_data/CapturedFiles/ | tail -n2 | head -n1`
echo $captured
#commandstring=$commandstring'   '$captured
captured=/home/$thiscamera/RMS_data/CapturedFiles/`ls /home/$thiscamera/RMS_data/CapturedFiles/ | tail -n3 | head -n1`
echo $captured
#commandstring=$commandstring'   '$captured
captured=/home/$thiscamera/RMS_data/CapturedFiles/`ls /home/$thiscamera/RMS_data/CapturedFiles/ | tail -n4 | head -n1`
echo $captured
#commandstring=$commandstring'   '$captured
captured=/home/$thiscamera/RMS_data/CapturedFiles/`ls /home/$thiscamera/RMS_data/CapturedFiles/ | tail -n5 | head -n1`
echo $captured
#commandstring=$commandstring'   '$captured
captured=/home/$thiscamera/RMS_data/CapturedFiles/`ls /home/$thiscamera/RMS_data/CapturedFiles/ | tail -n6 | head -n1`
echo $captured
#commandstring=$commandstring'   '$captured
done
cd ~/source/RMS


echo saving to /home/gmndata/trackstacks/$track_stack_date/combined/_$(hostname).jpg
commandstring='python -m Utils.TrackStack '$commandstring' -x --constellations  -c . -f6 -o /home/gmn/sendtoweb '$1
echo $commandstring
mkdir -p ~/sendtoweb
$commandstring

rsync /home/gmn/sendtoweb/*.jpg gmndata@192.168.1.230:/home/gmndata/trackstacks/$track_stack_date/combined/_$(hostname).jpg
rm -f /home/gmn/sendtoweb/*.jpg
echo $commandstring