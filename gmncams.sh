#!/bin/bash

#Convert .bz2 to cams format

gmn=$1

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

grep latitude .config
lat=$(grep latitude .config | cut -d":" -f2 | cut -d";" -f1)
lon=$(grep longitude .config | cut -d":" -f2 | cut -d";" -f1) 

echo Station $gmn at lat : $lat , lon : $lon


#pioneer

slat=-31.38779476
slon=116.0884533
distpioneer=$(echo "sqrt(($slat-$lat)^2+($slon-$lon)^2)" | bc -l)
echo Distance to Pioneer = $distpioneer

#walnut

slat=-32.0075881
slon=116.1356884
distwalnut=$(echo "sqrt(($slat-$lat)^2+($slon-$lon)^2)" | bc -l)
echo Distance to Walnut = $distwalnut

#bonney

slat=-32.3347585
slon=115.8229926
distbonney=$(echo "sqrt(($slat-$lat)^2+($slon-$lon)^2)" | bc -l)
echo Distance to Bonney = $distbonney

#lemongum

slat=-32.3543442
slon=115.80600764
distlemon=$(echo "sqrt(($slat-$lat)^2+($slon-$lon)^2)" | bc -l)
echo Distance to Lemon Gum = $distlemon

threshold=0.01

if (( $(echo "$distpioneer<$threshold" | bc -l) )); then location=pioneer ; fi
if (( $(echo "$distwalnut<$threshold" | bc -l) )); then location=walnut ; fi
if (( $(echo "$distbonney<$threshold" | bc -l) )); then location=bonney ; fi
if (( $(echo "$distlemon<$threshold" | bc -l) )); then location=lemon ; fi


echo Location was at $location


#Table of allocationx

#GMN ID		Bonney		Lemon		Walnut		Pioneer
#au000a		7107				7087
#au000c		7108				7088
#au000d		7109				7089
#au000e		7110				7090
#au000f		7111				7091
#au000g		7112				7092
#au000h		7113				7093
#au000k		7114				7094

#au0004		7095		7101
#au0006		7096		7102
#au0007		7097		7103
#au0008		7098		7104
#au0009		7099		7105
#au000l		7100		7106


#au000u								7081
#au000v								7082
#au000w								7083
#au000x								7084
#au000y								7085
#au000z								7086

cams=9999

if [ "$location" = "pioneer" ]; then
echo Handling location Pioneer

if [ "$gmn" = "au000u" ]; then cams=7081; fi
if [ "$gmn" = "au000v" ]; then cams=7082; fi
if [ "$gmn" = "au000w" ]; then cams=7083; fi
if [ "$gmn" = "au000x" ]; then cams=7084; fi
if [ "$gmn" = "au000y" ]; then cams=7085; fi
if [ "$gmn" = "au000z" ]; then cams=7086; fi

if [ "$gmn" = "au0011" ]; then cams=7081; fi
if [ "$gmn" = "au0012" ]; then cams=7082; fi
if [ "$gmn" = "au0013" ]; then cams=7083; fi



fi



if [ "$location" = "walnut" ]; then
echo Handling location Walnut

if [ "$gmn" = "au000a" ]; then cams=7087; fi
if [ "$gmn" = "au000c" ]; then cams=7088; fi
if [ "$gmn" = "au000d" ]; then cams=7089; fi
if [ "$gmn" = "au000e" ]; then cams=7090; fi
if [ "$gmn" = "au000f" ]; then cams=7091; fi
if [ "$gmn" = "au000g" ]; then cams=7092; fi
if [ "$gmn" = "au000h" ]; then cams=7093; fi
if [ "$gmn" = "au000k" ]; then cams=7094; fi



fi


if [ "$location" = "bonney" ]; then
echo Handling location Bonney

if [ "$gmn" = "au0004" ]; then cams=7095; fi
if [ "$gmn" = "au0006" ]; then cams=7096; fi
if [ "$gmn" = "au0007" ]; then cams=7097; fi
if [ "$gmn" = "au0008" ]; then cams=7098; fi
if [ "$gmn" = "au0009" ]; then cams=7099; fi
if [ "$gmn" = "au000l" ]; then cams=7100; fi

if [ "$gmn" = "au000a" ]; then cams=7107; fi
if [ "$gmn" = "au000c" ]; then cams=7108; fi
if [ "$gmn" = "au000d" ]; then cams=7109; fi
if [ "$gmn" = "au000e" ]; then cams=7110; fi
if [ "$gmn" = "au000f" ]; then cams=7112; fi
if [ "$gmn" = "au000g" ]; then cams=7113; fi
if [ "$gmn" = "au000h" ]; then cams=7114; fi
if [ "$gmn" = "au000k" ]; then cams=7115; fi




fi

if [ "$location" = "lemon" ]; then
echo Handling location Lemon Gum

if [ "$gmn" = "au0004" ]; then cams=7101; fi
if [ "$gmn" = "au0006" ]; then cams=7102; fi
if [ "$gmn" = "au0007" ]; then cams=7103; fi
if [ "$gmn" = "au0008" ]; then cams=7104; fi
if [ "$gmn" = "au0009" ]; then cams=7105; fi
if [ "$gmn" = "au000l" ]; then cams=7106; fi



fi


logger "camsconverter $gmn at $location lat:$lat, lon:$lon assigned $cams"
echo   "$gmn at $location lat:$lat, lon:$lon assigned $cams"






echo Change up a directory
cd ..


#temporary code during development
#rm -rf $workingdirectory
#exit

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

