#!/bin/bash

#Call this file from the users crontab every ten minutes

#cameras                 - one file for each camera
#systembooted            - run camerasreadytostart - set to night parameters, run RMS_Update, on completion move to cameras ready to start
#camerasreadytostart     - move to cameras running, run RMS_StartCapture
#camerasrunning          - 
#camerasstopped          - set to day parameters, run trackstack and email files
#readyforshutdown        - if all cameras are in readyforshutdown call shutdown or reboot


#sleep for a random length of time to reduce the number of race conditions
/home/gmn/scripts/povggmn/gmnsleep.sh $(whoami)

echo $backupcommand
mkdir -p /home/gmn/cameras/

cd ~/source/RMS
source ~/vRMS/bin/activate
logger -s -t $(whoami) running watchdog

if test -f /home/gmn/states/systembooted/$(whoami)						#is this camera booted

then

logger -s -t $(whoami) in systembooted
mv /home/gmn/states/systembooted/$(whoami) /home/gmn/states/camerasupdating/$(whoami)		#move out of booted and into updating
/home/gmn/scripts/povggmn/gmnsetcameraparamsnight.sh						#set to night mode
#logger -s -t $(whoami) set to night mode
~/source/RMS/Scripts/RMS_Update.sh								#update the gmnsoftware
nohup sshpass -p $1 rsync -a --partial-dir=partial/ ~/RMS_data/ArchivedFiles/*.bz2 rsync://$(whoami)@192.168.1.230:12000/$(whoami) &
logger -s -t $(whoami) RMS_Update completed
#/home/gmn/scripts/povggmn/gmnsetcameraparamsnight.sh						#set to night mode again in case some update was needed
sshpass -p $1 ssh gmndata@192.168.1.230 "mkdir -p ~/liveimages"
sshpass -p $1 ssh gmndata@192.168.1.230 "mkdir -p ~/$(whoami)/latest/"
ip a | grep 10.8. | cut -c 10-18 > cd /home/$(whoami)/RMS_data/ipaddress
sshpass -p $1 scp /home/$username/RMS_data/ipaddress gmndata@192.168.1.230:/home/gmndata/$(whoami)/latest/ipaddress

mv /home/gmn/states/camerasupdating/$(whoami) /home/gmn/states/camerasreadytostart/$(whoami)	#set camera as ready to start
logger -s -t $(whoami) in ready to start state

fi

if test -f /home/gmn/states/camerasreadytostart/$(whoami)					#is this camera ready to start

then

logger -s -t $(whoami) in camerasreadytostart
mv /home/gmn/states/camerasreadytostart/$(whoami) /home/gmn/states/camerasrunning/$(whoami)	#set camera as running
/usr/bin/screen -dmS $(whoami) /home/gmn/scripts/povggmn/gmnupdateandrun.sh

fi

if test -f /home/gmn/states/camerasrunning/$(whoami)						#is this camera running

then

logger -s -t $(whoami) writing live image							#do the routine work whilst the camera is runing
sshpass -p $1 scp ~/RMS_data/live.jpg gmndata@192.168.1.230:/home/gmndata/liveimages/$(whoami).jpg
sshpass -p $1 scp ~/source/RMS/.config gmndata@192.168.1.230:/home/gmndata/$(whoami)/latest
sshpass -p $1 scp ~/source/RMS/platepar* gmndata@192.168.1.230:/home/gmndata/$(whoami)/latest

username=$(whoami)
latestdirectory=`ls /home/$username/RMS_data/CapturedFiles | tail  -n1`
latestfile=`ls /home/$username/RMS_data/CapturedFiles/$latestdirectory/*.fits | tail  -n1`
sshpass -p $1 scp $latestfile gmndata@192.168.1.230:/home/gmndata/$(whoami)/latest
sshpass -p $1 scp /home/$username/RMS_data/CapturedFiles/$latestdirectory/*.txt gmndata@192.168.1.230:/home/gmndata/$(whoami)/latest

ip a | grep 10.8. | cut -c 10-18 > ~/RMS_data/ipaddress
sshpass -p $1 scp /home/$username/RMS_data/ipaddress gmndata@192.168.1.230:/home/gmndata/$(whoami)/latest/ipaddress

fi




if test -f /home/gmn/states/camerasstopped/$(whoami)						#is this camera stopped

then

#uncomment next line to only allow one final routines to run
#if [ "$(ls -A /home/gmn/states/runningfinalroutines)" ]; then 

#logger -s -t $(whoami) Not starting final routines $(ls /home/gmn/states/runningfinalroutines) is in process

#else

logger -s -t $(whoami) Starting final routines, no other camera in process
mv /home/gmn/states/camerasstopped/$(whoami) /home/gmn/states/runningfinalroutines/$(whoami)
username=$(whoami)
logger -s -t $(whoami) in camerasstopped
#/home/gmn/scripts/povggmn/gmnsetcameraparamsday.sh						#set to day mode
logger -s -t $(whoami) set to day mode
latestdirectory=`ls /home/$username/RMS_data/CapturedFiles | tail  -n1`				#run trackstack
latestdirectory=/home/$username/RMS_data/CapturedFiles/$latestdirectory
logger -s -t $(whoami) Starting trackstack in $latestdirectory
/home/gmn/scripts/povggmn/gmnrsync.sh $1
python -m Utils.TrackStack $latestdirectory 
sshpass -p $1 scp $latestdirectory/*.jpg gmndata@192.168.1.230:/home/gmndata/$(whoami)/latest
sshpass -p $1 scp $latestdirectory/*.bmp gmndata@192.168.1.230:/home/gmndata/$(whoami)/latest
cp $latestdirectory/*_track* /home/gmn/outbox
backuptime=`date +%Y%m%d%H%M%S`
backupcommand="mkdir -p ~/$(whoami)/backup; mv ~/$(whoami)/latest ~/$(whoami)/backup/$backuptime; mkdir -p ~/$(whoami)/latest"
echo Sending command
echo $backupcommand
sshpass -p $1 ssh gmndata@192.168.1.230 $backupcommand
mv /home/gmn/states/runningfinalroutines/$(whoami) /home/gmn/states/readyforshutdown/$(whoami)
logger -s -t $(whoami) Finished final routines

# fi

fi


cd /home/gmn/cameras/
readyforshutdown=TRUE
for camera in *
do
if test -f "/home/gmn/states/readyforshutdown/$camera"
then
logger -s -t $camera is in readyforshutdown
else
logger -s -t $camera is not in readyforshutdown
readyforshutdown=FALSE
fi

done

logger -s -t GMN Ready for shutdown is $readyforshutdown

if [ $readyforshutdown = "TRUE" ] 
then
logger -s -t GMN Running final preshutdown routine
mv /home/gmn/states/readyforshutdown/$(whoami) /home/gmn/states/runningfinalroutinesstation
logger -s -t GMN $(whoami) removed from ready for shutdown
source ~/vRMS/bin/activate
cd ~/source/RMS
/home/gmn/scripts/povggmn/gmnmultitrack.sh
logger -s -t GMN Cleared ready for shutdown directory
logger -s -t Wait 600 seconds so mails get sent
mv /home/gmn/states/runningfinalroutinesstation/$(whoami) /home/gmn/states/shutdowncalls
sleep 600
filestoupload=$(grep bz2 /home/*/RMS_data/*.inf | wc -l)
if [ $filestoupload -eq 0 ] 
then
logger -s -t  No files to upload
logger -s -t GMN Running sudo reboot
sudo reboot
else
logger -s -t  $filestoupload files to upload. Moving all cameras back to cameras running
mv /home/gmn/states/readyforshutdown/* /home/gmn/states/camerasrunning/
mv /home/gmn/states/shutdowncalls/*    /home/gmn/states/camerasrunning/
fi

else
logger -s -t GMN Not ready for shutdown
fi



