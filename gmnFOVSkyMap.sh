#!/bin/bash

#get username for paths
username=$(whoami)
target_dir=/home/$username/RMS_data/SkyMaps/$(hostname).png
#copy masks and platepar for all cameras

for camera in /home/gmn/cameras/*
do
  platepar_path="/home/$(basename $camera)/source/RMS/platepar_cmn2010.cal"
  mask_path="/home/$(basename $camera)/source/RMS/mask.bmp"
  mkdir -p /home/$username/platepars/$(basename $camera)/
  cp $platepar_path /home/$username/platepars/$(basename $camera)/
  cp $mask_path     /home/$username/platepars/$(basename $camera)/
  mkdir -p $target_dir/$camera/
  cp $platepar_path $target_dir/$camera/
  cp $mask_path     $target_dir/$camera/
done

cd ~/source/RMS/

mkdir -p /home/$username/RMS_data/SkyMaps/
python -m Utils.FOVSkyMap -n /home/gmn/platepars/

mv /home/$username/platepars/fov_sky_map.png $target_dir
echo Saved at
echo $target_dir