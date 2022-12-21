#!/bin/bash

#Convert .bz2 to cams format

gmn=$1

if [ -f /home/gmn/.$1converterrunning ]; 
then
echo Converter already running - quit
exit
fi

#touch /home/gmn/.$1converterrunning

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

gmn=9999

if [ "$location" = "pioneer" ]; then
echo Handling location Pioneer

if [ "$cams" = "au000u" ]; then gmn=7081; fi
if [ "$cams" = "au000v" ]; then gmn=7082; fi
if [ "$cams" = "au000w" ]; then gmn=7083; fi
if [ "$cams" = "au000x" ]; then gmn=7084; fi
if [ "$cams" = "au000y" ]; then gmn=7085; fi
if [ "$cams" = "au000z" ]; then gmn=7086; fi


fi



if [ "$location" = "walnut" ]; then
echo Handling location Walnut

if [ "$cams" = "au000a" ]; then gmn=7087; fi
if [ "$cams" = "au000c" ]; then gmn=7088; fi
if [ "$cams" = "au000d" ]; then gmn=7089; fi
if [ "$cams" = "au000e" ]; then gmn=7090; fi
if [ "$cams" = "au000f" ]; then gmn=7091; fi
if [ "$cams" = "au000g" ]; then gmn=7092; fi
if [ "$cams" = "au000h" ]; then gmn=7093; fi
if [ "$cams" = "au000k" ]; then gmn=7094; fi



fi


if [ "$location" = "bonney" ]; then
echo Handling location Bonney

if [ "$cams" = "au0004" ]; then gmn=7095; fi
if [ "$cams" = "au0006" ]; then gmn=7096; fi
if [ "$cams" = "au0007" ]; then gmn=7097; fi
if [ "$cams" = "au0008" ]; then gmn=7098; fi
if [ "$cams" = "au0009" ]; then gmn=7099; fi
if [ "$cams" = "au000l" ]; then gmn=7100; fi

if [ "$cams" = "au000a" ]; then gmn=7107; fi
if [ "$cams" = "au000c" ]; then gmn=7108; fi
if [ "$cams" = "au000d" ]; then gmn=7109; fi
if [ "$cams" = "au000e" ]; then gmn=7110; fi
if [ "$cams" = "au000f" ]; then gmn=7112; fi
if [ "$cams" = "au000g" ]; then gmn=7113; fi
if [ "$cams" = "au000h" ]; then gmn=7114; fi
if [ "$cams" = "au000k" ]; then gmn=7115; fi




fi

if [ "$location" = "lemon" ]; then
echo Handling location Lemon Gum

if [ "$cams" = "au0004" ]; then gmn=7101; fi
if [ "$cams" = "au0006" ]; then gmn=7102; fi
if [ "$cams" = "au0007" ]; then gmn=7103; fi
if [ "$cams" = "au0008" ]; then gmn=7104; fi
if [ "$cams" = "au0009" ]; then gmn=7105; fi
if [ "$cams" = "au000l" ]; then gmn=7106; fi



fi









echo Change up a directory
cd ..


#temporary code during development
rm -rf $workingdirectory
exit

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

