#!/bin/bash

#Upload to remote gmn server from data concentrator

#sleep for a random length of time to reduce the number of race conditions
#sleep $[ ( $RANDOM % 60 )  + 1 ]s

remote='gmn.uwo.ca'
cameraname=$(whoami | tr '[:lower:]' '[:upper:]')
echo Cameraname is : $cameraname
gmnsleep $cameraname



#Iterate through the local files looking for files which do not have a matching .uploaded file

for file in ~/files/incoming/*.bz2
do

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
exit
else
echo "File needs to be confirmed"
fi




#check to see if remote server incoming space is free

filesinincoming=$(sftp gmn.uwo.ca <<<"ls files/*.bz2" | grep $cameraname | wc -l)

echo Files in incoming : $filesinincoming

if [ $filesinincoming -eq 0 ];
then
echo Incoming is empty
else
echo Incoming is not empty
exit 1
fi


echo Filepath is $filepath
unconfirmedfilename=${filepath##*/}

#Get the size of the file on the remote machine

echo Look for $unconfirmedfilename on $remote
remotefilesize=$(sftp gmn.uwo.ca <<< "ls -la files/processed/" | grep $unconfirmedfilename |   awk '{print  $5}')
echo $unconfirmedfilename remote filesize is $remotefilesize

if [ -z "$remotefilesize" ];
then
echo "File probably does not exist, make an upload"
#upload goes here
sftp gmn.uwo.ca <<END
cd files
put $filepath
END
exit 2
fi


#Get the local size

localfilesize=$(wc -c $filepath | cut -d" " -f1)

echo $unconfirmedfilename " local filesize is"  $localfilesize

if [ $localfilesize -eq $remotefilesize ];
then
echo "File was uploaded successfully"
touch $filepath.confirmed
else
echo "File was not uploaded successfully, make an upload"
#upload goes here
sftp gmn.uwo.ca <<END
cd files
put $filepath
END

exit 3
fi
