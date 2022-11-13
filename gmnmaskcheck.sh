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
echo copying .config
sshpass -p $2 scp    $1:/home/$username/source/RMS/.config              ~/platepars/$username/
#copy the platepar file
echo copying platepar
sshpass -p $2 scp    $1:/home/$username/source/RMS/platepar_cmn2010.cal ~/platepars/$username/
echo copying ssh
#copy the .ssh key
sshpass -p $2 scp -r $1:/home/$username/.ssh                            ~/platepars/$username/

cp ~/platepars/$username/platepar_cmn2010.cal ~/platepars/$username/platepar_cmn2010.cal.bak
#find the latest directory
latestdirectory=`sshpass -p $2 ssh $1 'ls /home/'$username'/RMS_data/CapturedFiles | tail  -n1'`
penultimatedirectory=`sshpass -p $2 ssh $1 'ls /home/'$username'/RMS_data/CapturedFiles | tail  -n2 | head -n1'`
echo Latestdirectory is $latestdirectory
echo penultimatedirectory is $penultimatedirectory

echo Copying files
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


