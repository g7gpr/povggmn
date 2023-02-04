#!/bin/bash

#Convert .bz2 to cams format

if [ -f /home/gmn/.camsuploaderrunning ]; 
then
echo Converter already running - quit
exit
fi

touch /home/gmn/.camsuploaderrunning

echo "Uploading to CAMS"

if [ $(ls /home/gmn/sendtoseti/*.zip | wc -l) -eq '0' ]
then
echo No zip files to work on
rm  /home/gmn/.camsuploaderrunning
exit
fi


#Iterate through the local files looking for files which do not have a matching .camsconverted

for file in /home/gmn/sendtoseti/*.zip
do

if [ $file -nt $file.senttoseti ];
then
echo Worryingly $file is newer than confirmation
rm $file.sendtoseti
fi


if [ -f $file.senttoseti ] ;
then
echo $file.senttoseti exists
else
echo $file.senttoseti does not exist
filepath=$file
break
fi

done


if [ -z "$filepath" ];
then
echo "No files without senttoseti"
logger -s -t $(whoami) Nothing left to send
rm /home/gmn/.camsuploaderrunning
exit
else
echo "File needs to be sent to cams"
fi

echo Starting upload to cams of $filepath
filename=${filepath##*/}

if [[ $filename =~ "9999" ]] ; then 
 echo This is not valid - camera 9999
 mv $filepath /home/gmn/sendtoseti/qu
 rm /home/gmn/.camsuploaderrunning
 exit 1
fi


echo Which has the filename $filename

cd /home/gmn/sendtoseti
ftp -i -n << EOF
open camsftp.seti.org
user "anonymous@seti.org" "anonymous"
cd incoming/AUS
put $filename
EOF

touch $filepath.senttoseti



rm /home/gmn/.camsuploaderrunning

