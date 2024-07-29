#!/bin/bash

#get username for paths
username=$(whoami)
for camera in /home/gmn/cameras/*
do

  platepar_path="/home/$(basename $camera)/source/RMS/platepar_cmn2010.cal"
  mkdir -p /home/$username/platepars/$(basename $camera)/
  cp $platepar_path /home/$username/platepars/$(basename $camera)/
done

cd source/RMS

mkdir -p /home/$username/RMS_data/SkyMap
python -m Utils.FOVSkyMap -n /home/gmn/platepars/$(hostname)/
mv /home/$username/platepars/fov_sky_map.png /home/$username/RMS_data/platepars/$(hostname)/SkyMap
echo "File at /home/$username/RMS_data/SkyMap/"