#!/bin/bash

#Upload to remote gmn server from data concentrator

#sleep for a random length of time to reduce the number of race conditions
#sleep $[ ( $RANDOM % 60 )  + 1 ]s

if [ -f ~/.taruploaderrunning ];
then
echo Uploader already running - quit
exit
fi

touch ~/.taruploaderrunning

remote='gmn.uwo.ca'
cameraname=$(whoami | tr '[:lower:]' '[:upper:]')
echo Cameraname is : $cameraname
#/home/gmn/scripts/povggmn/gmnsleep.sh $(whoami)

logger -s -t $(whoami) Running uploader to $remote

#Iterate through the local files looking for files which do not have a matching .confirmed file

for file in ~/files/incoming/AU*.tar
do

if [ -f $file.confirmed ] ;
then
#echo $file.confirmed exists

 if [ $file -nt $file.confirmed ];
 then
 echo Worryingly $file is newer than confirmation
 rm $file.confirmed
 filepath=$file
 break
 fi
 
 if [ -f $file.uploaded ] ; 
 then
 echo Found an uploading lock file, will remove
 rm $file.uploaded
 fi

else
echo $file.confirmed does not exist
filepath=$file
break
fi

done

touch $filepath.uploading
sftp gmn.uwo.ca <<END
cd files
put $filepath
END
rm $filepath.uploading
touch $filepath.confirmed

rm ~/.taruploaderrunning
exit 2
