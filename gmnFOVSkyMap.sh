#!/bin/bash

#get username for paths
username=$(whoami)
target_dir=/home/$username/RMS_data/SkyMaps
#copy masks and platepar for all cameras

for camera in /home/gmn/cameras/*
do
  stationID = $(basname $camera)
  platepar_path="/home/$(basename $stationID)/source/RMS/platepar_cmn2010.cal"
  mask_path="/home/$(basename $stationID)/source/RMS/mask.bmp"
  mkdir -p /home/$username/platepars/$stationID/
  cp $platepar_path /home/$username/platepars/$stationID/
  cp $mask_path     /home/$username/platepars/$stationID/
  mkdir -p $target_dir/$camera/
  cp $platepar_path $target_dir/$stationID/
  cp $mask_path     $target_dir/$stationID/
done

cd ~/source/RMS/

mkdir -p /home/$username/RMS_data/SkyMaps/
python -m Utils.FOVSkyMap -n /home/gmn/platepars/

mv /home/$username/platepars/fov_sky_map.png $target_dir/$(hostname.png)
echo Saved at
echo $target_dir