#!/bin/bash

#This script will delete folders from a cameras RMS_Data directory if the directory is above quota
#gmnquota.sh 200 will check if the RMS_data directory is greater than 200GB, if it is then each time it is called it will delete one
#CapturedFiles folder, and one ArchivedFiles folder.

gbtokb=1048576
sleeptimer=$((10 + RANDOM % 11));
echo Sleeping for $sleeptimer seconds
#sleep $sleeptimer

quota=$(expr $1 \* $gbtokb)
spaceused=`du -d0 ~/RMS_data/ | cut -d '/' -f1 | xargs`
spaceusedh=`du -d0 -h ~/RMS_data/ | cut -d '/' -f1  | xargs`
echo Space used is $(expr $spaceused / $gbtokb)GB
echo Quota is      $(expr $quota     / $gbtokb)GB
if [ $spaceused -gt $quota ]
then

 echo Overquota
 nextcapturedfilesdirectory=`ls -d -rt ~/RMS_data/CapturedFiles/* | head -n1`
 nextarchivedfiles=`ls -d -rt ~/RMS_data/ArchivedFiles/* | head -n1`


 if [ -z $nextcapturedfilesdirectory ]
 then 
 echo No captured files directories to delete. Do nothing here.
 else 
 echo Next captured files directory to delete is $nextcapturedfilesdirectory
 rm -rf $nextcapturedfilesdirectory
 fi 

 if [ -z $nextarchivedfiles ]
 then 
 echo No archived files to delete. Do nothing here.
 else 
 echo Next archived files to delete is $nextarchivedfiles
 rm -rf $nextarchivedfiles

 fi 




 newspaceused=`du -d0  ~/RMS_data/ | cut -d '/' -f1 | xargs`
 newspaceusedh=`du -d0 -h  ~/RMS_data/ | cut -d '/' -f1 | xargs`
 echo Old space used was $spaceusedh"B"
 echo New space used was $newspaceusedh"B"
 echo Space freed was `expr $spaceused / $gbtokb - $newspaceused / $gbtokb`GB

else

echo Underquota

fi
