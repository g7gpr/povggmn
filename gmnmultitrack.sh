#!/bin/bash

#This script will run a track stack for all the cameras on this system

thiscamera=au000u
for thiscamerapath in /home/gmn/cameras/*
do
thiscamera=`echo $thiscamerapath | cut -d'/' -f5-`
captured=/home/$thiscamera/RMS_data/CapturedFiles/`ls /home/$thiscamera/RMS_data/CapturedFiles/ | tail -n1 | head -n1`
echo $captured
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
commandstring='python Utils/TrackStack.py '$commandstring' --constellations  -c . -f6 -o /home/gmn/outbox '$1
echo $commandstring
$commandstring
