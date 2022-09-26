#!/bin/bash
#Script to show the size of the users RMS_data directory. The cameraname is passed by an argument
#gmndiskuseage.sh au0004

gbtokb=1048576
spaceused=`du -d0 /home/$1/RMS_data/ | cut -d '/' -f1`
spaceusedh=`du -d0 -h /home/$1/RMS_data/ | cut -d '/' -f1`
echo Space used by $1 is $(expr $spaceused / $gbtokb)GB
