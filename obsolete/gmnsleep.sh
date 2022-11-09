#!/bin/bash
cameraname=$1
cnwc=${cameraname:2}
delay=$((36#$cnwc))
echo Sleeping for $delay
sleep $delay
