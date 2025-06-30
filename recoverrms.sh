#!/bin/bash
cd ~/source
rm -rf RMS
rsync -ah --include ".*" /home/gmn/source/RMS .
git checkout prerelease
cd ~/source/RMS
last_archive=$(stat ~/RMS_data/CapturedFiles/* | grep File: | tail -n1 | cut -d ':' -f2)
echo Pulling files from $last_archive
cp last_archive/mask.bmp last_archive/.config last_archive/platepar_cmn2010.cal .
echo .config file has $(grep stationID .config)
echo platepar file has $(grep station_code platepar_cmn2010.cal)