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

mkdir -p /home/$username/RMS_data/SkyMap/$(hostname)
python -m Utils.FOVSkyMap -n /home/gmn/platepars/
target_dir=/home/$username/RMS_data/SkyMap/$(hostname)/SkyMap
mv /home/$username/platepars/fov_sky_map.png $target_dir
echo Saved at
echo $target_dir