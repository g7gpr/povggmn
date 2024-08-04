#!/bin/bash

#Call this file from the users crontab every ten minutes

#cameras                 - one file for each camera
#systembooted            - run camerasreadytostart - set to night parameters, run RMS_Update, on completion move to cameras ready to start
#camerasreadytostart     - move to cameras running, run RMS_StartCapture
#camerasrunning          - 
#camerasstopped          - set to day parameters, run trackstack and email files
#readyforshutdown        - if all cameras are in readyforshutdown call shutdown or reboot


#sleep for a random length of time to reduce the number of race conditions
username=$(whoami)
/home/gmn/scripts/povggmn/gmnsleep.sh $(whoami)

echo Username is $username
mkdir -p /home/gmn/cameras/
mkdir -p /home/gmn/$(whoami)



echo Writing the ip address 
ipaddress=$(hostname -I)
echo ip address : $ipaddress
echo "$ipaddress" > /home/$(whoami)/RMS_data/$(whoami)".ip"
scp   /home/$username/RMS_data/$(whoami)".ip" gmndata@192.168.1.230:~/$(hostname).ip

cd ~/source/RMS
source ~/vRMS/bin/activate
logger -s -t $(whoami) running watchdog
git log -1 | grep commit > ~/gitlog


if test -f /home/gmn/states/systembooted/$(whoami)						#is this camera booted

then

logger -s -t $(whoami) in systembooted
mv /home/gmn/states/systembooted/$(whoami) /home/gmn/states/camerasupdating/$(whoami)		#move out of booted and into updating
~/source/RMS/Scripts/RMS_Update.sh								#update the gmnsoftware
logger -s -t $(whoami) RMS_Update completed
/home/gmn/scripts/povggmn/gmnsshrsync.sh
/home/gmn/scripts/povggmn/gmnsetcameraparamsnight.sh						#set to night mode again in case some update was needed
ssh gmndata@192.168.1.230 "mkdir -p ~/$(hostname)/$(whoami)/latest/"

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
rsync -av  ~/RMS_data/live.jpg                gmndata@192.168.1.230:~/$(hostname)/$(whoami).jpg
rsync -av  ~/source/RMS/mask.bmp              gmndata@192.168.1.230:~/$(hostname)/$(whoami)_mask.bmp

ip a | grep 10.8. | cut -c 10-18 > ~/RMS_data/ipaddress
scp /home/$username/RMS_data/ipaddress gmndata@192.168.1.230:~/$(hostname)/$(whoami)/ipaddress

fi




if test -f /home/gmn/states/camerasstopped/$(whoami)						#is this camera stopped

then

#uncomment next line to only allow one final routines to run
#if [ "$(ls -A /home/gmn/states/runningfinalroutines)" ]; then 

#logger -s -t $(whoami) Not starting final routines $(ls /home/gmn/states/runningfinalroutines) is in process

#else

mv /home/gmn/states/camerasstopped/$(whoami) /home/gmn/states/runningfinalroutines/$(whoami)
username=$(whoami)
logger -s -t $(whoami) in camerasstopped
latestdirectory=`ls /home/$username/RMS_data/CapturedFiles | tail  -n1`				#run trackstack
latestdirectory=/home/$username/RMS_data/CapturedFiles/$latestdirectory
track_stack_date=$(echo $latestdirectory | cut -d_ -f3)
echo Saving to /home/gmndata/trackstacks/$(track_stack_date)/
logger -s -t $(whoami) Starting trackstack in $latestdirectory
/home/gmn/scripts/povggmn/gmnsshrsync.sh 
python -m Utils.TrackStack $latestdirectory --constellations
scp $latestdirectory/*.jpg gmndata@192.168.1.230:/home/gmndata/$(hostname)/$(whoami)/latest
scp $latestdirectory/*.bmp gmndata@192.168.1.230:/home/gmndata/$(hostname)/$(whoami)/latest

rsync $latestdirectory/*_track* gmndata@192.168.1.230:/home/gmndata/trackstacks/$(track_stack_date)/
backuptime=`date +%Y%m%d%H%M%S`
backupcommand="mkdir -p ~/$(whoami)/backup; mv ~/$(whoami)/latest ~/$(whoami)/backup/$backuptime; mkdir -p ~/backups/$(whoami)/latest; exit"
echo Sending command
echo $backupcommand
ssh gmndata@192.168.1.230 $backupcommand
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

#make the package of backup information
cp ~/source/RMS/mask.bmp             /home/gmn/$(hostname)/$(whoami)/
cp ~/source/RMS/.config              /home/gmn/$(hostname)/$(whoami)/
cp ~/source/RMS/platepar_cmn2010.cal /home/gmn/$(hostname)/$(whoami)/
scp -r  /home/gmn/$hostname/$(whoami)         gmndata@192.168.1.230:/home/gmndata/stations/$(hostname)
sudo killall rsync
sleep 600
sudo reboot
else
logger -s -t GMN Not ready for shutdown
fi



