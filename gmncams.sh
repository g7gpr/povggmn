#!/bin/bash

#Convert .bz2 to cams format

gmn=$1
cams=$2

if [ -f /home/gmn/.$1converterrunning ]; 
then
echo Converter already running - quit
exit
fi

touch /home/gmn/.$1converterrunning

echo "Converting to camera code "$cams

if [ $(ls /home/$gmn/files/incoming/*.bz2 | wc -l) -eq '0' ]
then
echo No .bz2 files to work on
rm  /home/gmn/.$1converterrunning
exit
fi


#Iterate through the local files looking for files which do not have a matching .camsconverted

for file in /home/$gmn/files/incoming/*.bz2
do

if [ $file -nt $file.camsconverted ];
then
echo Worryingly $file is newer than confirmation
rm $file.camsconverted
fi


if [ -f $file.camsconverted ] ;
then
echo $file.camsconverted exists
else
echo $file.camsconverted does not exist
filepath=$file
break
fi

done


if [ -z "$filepath" ];
then
echo "No files without camsconverted"
logger -s -t $(whoami) Nothing left to convert
rm /home/gmn/.$1converterrunning
exit
else
echo "File needs to be converted"
fi

echo Starting conversion to cams format of $filepath

filename=${filepath##*/}
workingdirectory=/home/$gmn/files/incoming/${filename:0:29}

echo Incoming filename is $filename


echo Create working directory as $workingdirectory
mkdir $workingdirectory

echo Copy $filename to $workingdirectory
cp $filepath $workingdirectory/

echo Change to $workingdirectory
cd $workingdirectory

echo Extract bz2 file
tar -xf $filename

echo delete bz2 file
rm $filename


echo Change up a directory
cd ..

cd /home/gmn/source/RMS

source /home/gmn/vRMS/bin/activate
echo Running converter on $workingdirectory
python -m RMS.CamsConvert $workingdirectory -s $cams

echo Copying zip file from $workingdirectory
cp $workingdirectory/*.zip /home/gmn/sendtoseti/
touch $file.camsconverted

echo Remove working directory $workingdirectory
rm -rf $workingdirectory
cd ~/files/incoming

rm /home/gmn/.$1converterrunning

