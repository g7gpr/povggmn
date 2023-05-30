#!/bin/bash
for camera in /home/au*
do
camera=$(basename $camera)
echo $camera
sudo su $(basename $camera) -c "bash -c '/home/gmn/scripts/povggmn/comparelr.sh'"
done
