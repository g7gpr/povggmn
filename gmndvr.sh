#!/bin/bash

CAMERA_ADDRESS=$1
DATA_DIR=/home/$(whoami)/video_data
mkdir -p $DATA_DIR
echo "Made " $DATA_DIR

# Record stream with ffmpeg
ffmpeg -y -nostdin -nostats -stimeout 5000000 -i "rtsp://$CAMERA_ADDRESS:554/user=admin&password=&channel=1&stream=0.sdp" -f segment -strftime 1 -segment_time 60 -reset_timestamps 1 -vcodec copy $DATA_DIR/%Y%m%d_%H%M%S_$CAMERA_ADDRESS.mkv & 


# Delete data older than 7 days
while [[ 1 ]]; do
    find $DATA_DIR -type f -mtime +7 -name '*.mkv' -execdir rm -- '{}' \;
    sleep 60
done
