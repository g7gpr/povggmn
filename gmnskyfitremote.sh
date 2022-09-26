#!/bin/bash

#This script pulls the platepars and .config files from a remote machine, starts SkyFit2 on the local machine and then pushes the updated files back to the remote machine
#It starts skyfit on the local machine and when skyfit has finished, it saves the platepars back to the remote machine. 
#It also holds backups of the key files.

#Process arguments

echo "User@domain:"$1
echo "Password":$2
username=$(echo $1  | cut -d@ -f1)
echo Username = $username

#make a directory for the backups

backuptime=`date +%Y%m%d%H%M%S`
mkdir -p ~/platepars/$username/backup/$backuptime
mkdir -p ~/platepars/$username/penultimate

#copy everything into the backups

mv ~/platepars/$username/*.cal  ~/platepars/$username/backup/$backuptime
mv ~/platepars/$username/*.fits ~/platepars/$username/backup/$backuptime
mv ~/platepars/$username/*.bmp  ~/platepars/$username/backup/$backuptime
mv ~/platepars/$username/*.png  ~/platepars/$username/backup/$backuptime
mv ~/platepars/$username/*.jpg  ~/platepars/$username/backup/$backuptime
mv ~/platepars/$username/*.bz2  ~/platepars/$username/backup/$backuptime
mv ~/platepars/$username/.ssh  ~/platepars/$username/backup/$backuptime



#copy from the remote machine to local machine

#copy the .config file
sshpass -p $2 scp    $1:/home/$username/source/RMS/.config              ~/platepars/$username/
#copy the platepar file
sshpass -p $2 scp    $1:/home/$username/source/RMS/platepar_cmn2010.cal ~/platepars/$username/
#copy the .ssh key
sshpass -p $2 scp -r $1:/home/$username/.ssh                            ~/platepars/$username/


cp ~/platepars/$username/platepar_cmn2010.cal ~/platepars/$username/platepar_cmn2010.cal.bak
#find the latest directory
latestdirectory=`sshpass -p $2 ssh $1 'ls /home/'$username'/RMS_data/CapturedFiles | tail  -n1'`
penultimatedirectory=`sshpass -p $2 ssh $1 'ls /home/'$username'/RMS_data/CapturedFiles | tail  -n2 | head -n1'`
echo Latestdirectory is $latestdirectory
echo penultimatedirectory is $penultimatedirectory

#make the list of files to get
latestfile=`sshpass -p $2 ssh $1 'ls /home/'$username'/RMS_data/CapturedFiles/'$latestdirectory'/*.fits | tail  -n1'`
onehouragofile=`sshpass -p $2 ssh $1 'ls /home/'$username'/RMS_data/CapturedFiles/'$latestdirectory'/*.fits | tail  -n360 |  head -n1'`
twohouragofile=`sshpass -p $2 ssh $1 'ls /home/'$username'/RMS_data/CapturedFiles/'$latestdirectory'/*.fits | tail  -n720 |  head -n1'`
firsthourfile=`sshpass -p $2 ssh $1 'ls /home/'$username'/RMS_data/CapturedFiles/'$latestdirectory'/*.fits | head  -n720 |  tail -n1'`
#Run trackstack in penultimate directory
sshcommand='source ~/vRMS/bin/activate; cd ~/source/RMS ; python -m Utils.TrackStack ~/RMS_data/CapturedFiles/'$penultimatedirectory' >/dev/null'
echo Remote command for trackstack is $sshcommand
`sshpass -p $2 ssh $1 $sshcommand ; sshpass -p $2 scp $1:/home/$username/RMS_data/CapturedFiles/$penultimatedirectory/*_track_stack.jpg ~/platepars/$username/penultimate/` & >/dev/null  2>&1

echo Latestfile = $latestfile
echo Onehouragofile = $onehouragofile
echo Twohouragofile = $twohouragofile
echo Firsthourfile = $firsthourfile
#start copying across
echo 0%
sshpass -p $2 scp $1:$latestfile ~/platepars/$username/
echo 25%
sshpass -p $2 scp $1:$onehouragofile ~/platepars/$username/
echo 50%
sshpass -p $2 scp $1:$twohouragofile ~/platepars/$username/
echo 75%
sshpass -p $2 scp $1:$firsthourfile ~/platepars/$username/
echo 100%

#now get some files for context. This can be done in the background as not required for platepar development
echo Copying other files
sshpass -p $2 scp $1:/home/$username/RMS_data/CapturedFiles/$penultimatedirectory/*.bmp ~/platepars/$username/penultimate 
sshpass -p $2 scp $1:/home/$username/RMS_data/live.jpg ~/platepars/$username/$username.jpg &
sshpass -p $2 scp $1:/home/$username/source/RMS/mask.bmp ~/platepars/$username/penultimate/mask.bmp 
composite -blend 30  ~/platepars/$username/penultimate/mask.bmp    ~/platepars/$username/penultimate/flat.bmp ~/platepars/$username/penultimate/flatandmask.bmp
sshpass -p $2 scp $1:/home/$username/RMS_data/CapturedFiles/$latestdirectory/*.jpg ~/platepars/$username/ &
sshpass -p $2 scp $1:/home/$username/RMS_data/CapturedFiles/$latestdirectory/*.bmp ~/platepars/$username/ &
sshpass -p $2 scp $1:/home/$username/RMS_data/CapturedFiles/$latestdirectory/*.png ~/platepars/$username/ &
sshpass -p $2 scp $1:/home/$username/RMS_data/CapturedFiles/$latestdirectory/*.bz2  ~/platepars/$username/ &
sshpass -p $2 scp $1:/home/$username/RMS_data/CapturedFiles/$latestdirectory/*.txt  ~/platepars/$username/ &
sshpass -p $2 scp $1:/home/$username/RMS_data/live.jpg ~/platepars/$username/$username.jpg &

echo finished copying other files

#enter the virtual environment
source ~/vRMS/bin/activate
#change the the working directory
cd ~/source/RMS/
python -m Utils.SkyFit2 -c ~/platepars/$username/.config ~/platepars/$username
#Once user has finished put platepar back in ~/source/RMS and also in latest directory 
echo Copying plateplars back to /home/$username/source/RMS/
sshpass -p $2 scp ~/platepars/$username/platepar_cmn2010.cal $1:/home/$username/source/RMS/ &
echo And to $latestdirectory
sshpass -p $2 scp ~/platepars/$username/platepar_cmn2010.cal $1:/home/$username/RMS_data/CapturedFiles/$latestdirectory/ &


