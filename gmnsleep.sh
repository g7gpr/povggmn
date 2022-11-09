#!/bin/bash
#Script to hold any process by the duration in seconds of the position of the camera in the /home directory


cameraname=$1
delay=$(ls /home | grep -n $cameraname | cut -d':' -f1)
#cnwc=${cameraname:2}
#delay=$((36#$cnwc))
echo Sleeping for $delay
sleep $delay
