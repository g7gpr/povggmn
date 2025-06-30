#!/bin/bash
cd ~/source
rm -rf RMS
rsync -ah --include ".*" /home/gmn/source/RMS .
cd ~/source/RMS
mv .config .configTemplate
git reset --hard
git checkout prerelease
for dir in ~/RMS_data/ArchivedFiles/*/; do
    last_archive=$dir;
    stationID=$(grep stationID ${last_archive}.config | cut -d ":" -f2)
    echo ${stationID}
    if [[ stationID != "XX0001"]]; then
      break
    done
echo Pulling files from ${last_archive}
cp ${last_archive}mask.bmp ${last_archive}.config ${last_archive}platepar_cmn2010.cal .
python -m Utils.MigrateConfig -u
echo .config file has $(grep stationID .config | cut -d ":" -f2 )
echo platepar file has $(grep station_code platepar_cmn2010.cal | cut -d ":" -f2)

