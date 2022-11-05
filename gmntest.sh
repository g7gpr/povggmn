#!/bin/bash
filestoupload=$(grep bz2 /home/*/RMS_data/*.inf | wc -l)
if [ $filestoupload -eq 0 ] 
then
echo No files to upload
else
echo $filestoupload files to upload
fi
