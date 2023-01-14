#!/bin/bash
echo $1: bz2:$(ls /home/$1/files/incoming/*.bz2 | wc -l), converted to cams:$(ls /home/$1/files/incoming/*.camsconverted | wc -l), sent to gmn: $(ls /home/$1/files/incoming/*.confirmed | wc -l)
