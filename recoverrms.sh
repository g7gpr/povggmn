#!/bin/bash

# Clear away RMS
cd ~/source; rm -rf RMS

# Pull a copy of the code, including hidden files
rsync -ah --include ".*" /home/gmn/source/RMS .

# Change into RMS
cd ~/source/RMS

# Make the .configTemplate
mv .config .configTemplate

# Reset
git reset --hard; git checkout prerelease

# Find the newest .config in archives
for dir in ~/RMS_data/ArchivedFiles/*/; do

    stationID=$(grep stationID ${last_archive}.config | cut -d ":" -f2)
    if [[ stationID != "XX0001" ]]; then
        last_archive_for_config=$dir;
    fi
    done

cp ${last_archive_for_config}mask.bmp ${last_archive_for_config}.config .

# Find the newest platepar in archives
for dir in ~/RMS_data/ArchivedFiles/*/; do

    stationID=$(grep station_code ${last_archive}platepar_cmn2010.cal | cut -d ":" -f2 | tr -cd '[:alnum:]')
    if [[ stationID != "XX0001" ]]; then
        last_archive_for_platepar=$dir;
    fi
    done

cp ${last_archive_for_platepar}platepar_cmn2010.cal .

# Do config migration
python -m Utils.MigrateConfig -u

# Echo where files were found
echo Got mask and .config from ${last_archive_for_config}
echo Gpt platepar from ${last_archive_for_platepar}


echo ' .config file has stationID '$(grep stationID .config | cut -d ":" -f2 | tr -cd '[:alnum:]' )
echo 'platepar file has stationID '$(grep station_code platepar_cmn2010.cal | cut -d ":" -f2 | tr -cd '[:alnum:]')

