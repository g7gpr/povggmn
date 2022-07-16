#!/bin/bash

#Call this file from the users crontab every ten minutes

#cameras                 - one file for each camera
#systembooted            - run camerasreadytostart - set to night parameters, run RMS_Update, on completion move to cameras ready to start
#camerasreadytostart     - move to cameras running, run RMS_StartCapture
#camerasrunning          - 
#camerasstopped          - set to day parameters, run trackstack and email files
#readyforshutdown        - if all cameras are in readyforshutdown call shutdown or reboot

cd ~/source/RMS
source ~/vRMS/bin/activate
logger -s -t $(whoami) running watchdog

if test -f /home/gmn/states/systembooted/$(whoami)						#is this camera booted

then

logger -s -t $(whoami) in systembooted
/home/gmn/scripts/povggmn/gmnsetcameraparamsnight.sh						#set to night mode
logger -s -t $(whoami) set to night mode
mv /home/gmn/states/systembooted/$(whoami) /home/gmn/states/camerasupdating/$(whoami)
~/source/RMS/Scripts/RMS_Update.sh									#update the gmnsoftware
logger -s -t $(whoami) RMS_Update completed
mv /home/gmn/states/camerasupdating/$(whoami) /home/gmn/states/camerasreadytostart/$(whoami)
logger -s -t $(whoami) in ready to start state

fi

if test -f /home/gmn/states/camerasreadytostart/$(whoami)					#is this camera ready to start

then

logger -s -t $(whoami) in camerasreadytostart
mv /home/gmn/states/camerasreadytostart/$(whoami) /home/gmn/states/camerasrunning/$(whoami)
/usr/bin/screen -dmS $(whoami) /home/gmn/scripts/povggmn/gmnupdateandrun.sh

fi

if test -f /home/gmn/states/camerasrunning/$(whoami)					#is this camera ready to start

then

logger -s -t $(whoami) writing live image
sshpass -p $1 scp ~/RMS_data/live.jpg gmndata@192.168.1.230:/home/gmndata/liveimages/$(whoami).jpg
sshpass -p $1 scp ~/source/RMS/.config gmndata@192.168.1.230:/home/gmndata/$(whoami)/latest
sshpass -p $1 scp ~/source/RMS/platepar* gmndata@192.168.1.230:/home/gmndata/$(whoami)/latest

username=$(whoami)
latestdirectory=`ls /home/$username/RMS_data/CapturedFiles | tail  -n1`
echo Latestdirectory is $latestdirectory
latestfile=`ls /home/$username/RMS_data/CapturedFiles/$latestdirectory/*.fits | tail  -n1`
echo Latestfile is $latestfile
sshpass -p $1 scp $latestfile gmndata@192.168.1.230:/home/gmndata/$(whoami)/latest

fi




if test -f /home/gmn/states/camerasstopped/$(whoami)						#is this camera stopped

then

mv /home/gmn/states/camerasstopped/$(whoami) /home/gmn/states/runningfinalroutines/$(whoami)
username=$(whoami)
logger -s -t $(whoami) in camerasstopped
/home/gmn/scripts/povggmn/gmnsetcameraparamsday.sh							#set to day mode
logger -s -t $(whoami) set to day mode
latestdirectory=`ls /home/$username/RMS_data/CapturedFiles | tail  -n1`
latestdirectory=/home/$username/RMS_data/CapturedFiles/$latestdirectory
logger -s -t $(whoami) Starting trackstack in $latestdirectory
python -m Utils.TrackStack $latestdirectory 
echo Trackstack from $username was formed from files in $latestdirectory.  | mail -s "$username trackstack" g7gpr@outlook.com davidrollinson@hotmail.com -A $latestdirectory/*_track*
mv /home/gmn/states/runningfinalroutines/$(whoami) /home/gmn/states/readyforshutdown/$(whoami)

fi


cd /home/gmn/cameras/
readyforshutdown=TRUE
for camera in *
do
if test -f "/home/gmn/states/readyforshutdown/$camera"
then
logger -s -t $camera is in shutdown
else
logger -s -t $camera is not in readyforshutdown
readyforshutdown=FALSE
fi

done

logger -s -t GMN Ready for shutdown is $readyforshutdown

if [ $readyforshutdown = "TRUE" ] 
then
logger -s -t GMN Running final preshutdown routines
rm /home/gmn/states/readyforshutdown/*
logger -s -t GMN Cleared ready for shutdown directory
logger -s -t GMN Running sudo reboot
sudo reboot
else
logger -s -t GMN Not ready for shutdown
fi



