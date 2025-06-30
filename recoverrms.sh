#!/bin/bash
cd ~/source
rm -rf RMS
rsync -ah --include ".*" /home/gmn/source/RMS .
git checkout prerelease
cd ~/source/RMS
for dir in ~/RMS_data/ArchivedFiles/*/; do last_archive=$dir; done
echo Pulling files from ${last_archive}
cp ${last_archive}mask.bmp ${last_archive}.config ${last_archive}platepar_cmn2010.cal .
python -m Utils.MigrateConfig -u
echo .config file has $(grep stationID .config | cut -d ":" -f2 )
echo platepar file has $(grep station_code platepar_cmn2010.cal | cut -d ":" -f2)