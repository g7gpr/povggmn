#!/bin/bash

#This script changes to the ~/source/RMS, requests an update, and starts capture

source ~/vRMS/bin/activate
cd ~/source/RMS
./Scripts/RMS_Update.sh
/home/gmn/scripts/povggmn/gmnsetcameraparamsnight.sh
./Scripts/RMS_StartCapture.sh

