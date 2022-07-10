#!/bin/bash

#This script keep the size of the RMS_data directory for each user under control
#rmsquota.sh 200 will check if the RMS_data directory is greater than 200GB, if it is then each time it is called it will delete one 
#CapturedFiles folder, and one ArchivedFiles folder. Only needs to be called once each day.

gbtokb=1048576
sleeptimer=$((10 + RANDOM % 11));
echo Sleeping for $sleeptimer seconds
sleep $sleeptimer

quota=$(expr $1 \* $gbtokb)
spaceused=`du -d0 ~/RMS_data/ | cut -d '/' -f1`
spaceusedh=`du -d0 -h ~/RMS_data/ | cut -d '/' -f1`
echo Space used is $(expr $spaceused / $gbtokb)
echo Quota is      $(expr $quota     / $gbtokb)
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
 rm -rf $nextarchivedfilesdirectory

 fi 

 newspaceused=`du -d0  ~/RMS_data/ | cut -d '/' -f1`
 newspaceusedh=`du -d0 -h  ~/RMS_data/ | cut -d '/' -f1`
 echo Old space used was $spaceusedh
 echo New space used was $newspaceusedh 
 echo Space freed was `expr $spaceused / $gbtokb - $newspaceused / $gbtokb`

else

echo Underquota

fi
