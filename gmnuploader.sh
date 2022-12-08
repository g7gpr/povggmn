#!/bin/bash

#Upload to remote gmn server from data concentrator

#sleep for a random length of time to reduce the number of race conditions
#sleep $[ ( $RANDOM % 60 )  + 1 ]s

if [ -f ~/.uploaderrunning ]; 
then
echo Uploader already running - quit
exit
fi

touch ~/.uploaderrunning

remote='gmn.uwo.ca'
cameraname=$(whoami | tr '[:lower:]' '[:upper:]')
echo Cameraname is : $cameraname
/home/gmn/scripts/povggmn/gmnsleep.sh $(whoami)

logger -s -t $(whoami) Running uploader to $remote

#Iterate through the local files looking for files which do not have a matching .uploaded file

for file in ~/files/incoming/*.bz2
do

if [ $file -nt $file.confirmed ];
then
echo Worryingly $file is newer than confirmation
rm $file.confirmed
fi


if [ -f $file.confirmed ] ;
then
echo $file.confirmed exists
else
echo $file.confirmed does not exist
filepath=$file
break
fi

done

if [ -z "$filepath" ];
then
echo "No files without confirmation"
logger -s -t $(whoami) Nothing to upload to $remote
rm ~/.uploaderrunning
exit
else
echo "File needs to be confirmed"
fi

#check to see if remote server incoming space is free

filesinincoming=$(sftp $remote <<<"ls files/*.bz2" | grep $cameraname | wc -l)

echo Files in incoming : $filesinincoming

if [ $filesinincoming -eq 0 ];
then
echo Incoming is empty
else
echo Incoming is not empty - which is strange, why is the file still there? Is it corrupted?

sftp $remote <<< "ls -la files/*.bz2" 1> fileinincoming

echo File in incoming
incomingfilesize=$(more fileinincoming |   awk '{print  $5}')

incomingfilepath=$(more fileinincoming |   awk '{print  $9}')
echo Filepath $incomingfilepath

incomingfilename=${incomingfilepath##*/}
echo Incoming filename is $incomingfilename

localfilesize=$(wc -c $filepath | cut -d" " -f1)
echo "Remote filesize :"$incomingfilesize
echo "Local filesize  : "$localfilesize

if [ $incomingfilesize -eq $localfilesize ] ;
then
echo Local and remote file sizes are the same. Nothing do do.
else
echo Local and remote file sizes are different. Remove corrupt file from incoming.
echo $incomingfilepath
rmcommandstring="rm files/$incomingfilename"
echo Command string is : $rmcommandstring
sftp $remote <<< $rmcommandstring

fi



rm ~/.uploaderrunning
exit 1
fi


echo Filepath is $filepath
unconfirmedfilename=${filepath##*/}

localfilesize=$(wc -c $filepath | cut -d" " -f1)

echo Remote file size is $incomingfilesize
echo Local file size is  $localfilesize

#Get the size of the file on the remote machine

echo Look for $unconfirmedfilename on $remote
remotefilesize=$(sftp $remote <<< "ls -la files/processed/" | grep $unconfirmedfilename |   awk '{print  $5}')
echo $unconfirmedfilename remote filesize is $remotefilesize

if [ -z "$remotefilesize" ];
then
echo "File probably does not exist, make an upload"
#upload goes here
sftp gmn.uwo.ca <<END
cd files
put $filepath
END
logger -s -t $(whoami) Uploaded $unconfirmedfilename because it was not found on $remote
rm ~/.uploaderrunning
exit 2
fi


#Get the local size

localfilesize=$(wc -c $filepath | cut -d" " -f1)

echo $unconfirmedfilename " local filesize is"  $localfilesize

if [ $localfilesize -eq $remotefilesize ];
then
echo "File was uploaded successfully"
touch $filepath.confirmed
logger -s -t $unconfirmedfilename was found with the correct size at $remote
else
echo "File was not uploaded successfully, make an upload"
#upload goes here
sftp gmn.uwo.ca <<END
cd files
put $filepath
END
logger -s -t $(whoami) Uploaded $unconfirmedfilename because it was corrupted at $remote
rm ~/.uploaderrunning
exit 3
fi


rm ~/.uploaderrunning
