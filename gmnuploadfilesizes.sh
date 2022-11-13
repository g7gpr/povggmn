#!/bin/bash
#latestarchiveddirectory=`ls /home/$username/RMS_data/ArchivedFiles | tail  -n2 | head -n1`
#latestarchiveddirectory=/home/$username/RMS_data/ArchivedFiles/$latestarchiveddirectory
while IFS= read -r line; do
    ls -lah --block-size=M $line
done < "$1"
