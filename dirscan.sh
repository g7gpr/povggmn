#!/bin/bash
for cam in /home/gmn/cameras/*
 do
 echo $(basename $cam)    $(ls /home/$(basename $cam)/RMS_data/CapturedFiles/ | wc -l)
done
df -h | grep 'dev/' | head -n1