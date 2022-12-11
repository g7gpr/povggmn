#!/bin/bash
echo bz2                  $(ls /home/$1/files/incoming/*.bz2 | wc -l)
echo sent to cams      $(ls /home/$1/files/incoming/*.camsconverted | wc -l)
echo sent to gmn         $(ls /home/$1/files/incoming/*.confirmed | wc -l)
