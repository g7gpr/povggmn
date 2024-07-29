#!/bin/bash

username=$(whoami)
echo $username
for camera in /home/gmn/cameras/*
do
  echo Copying $(basename $camera)
  platepar_path="/home/$(basename $camera)/source/RMS/platepar_cmn2010.cal"
  mkdir -p /home/gmn/platepars/$(basename $camera)/
  cp $platepar_path /home/gmn/platepars/$(basename $camera)/
done

cd source/RMS
pwd
mkdir -p /home/gmn/RMS_data/SkyMap
python -m Utils.FOVSkyMap -n /home/gmn/platepars/
mv /home/gmn/platepars/fov_sky_map.png /home/gmnplatepars