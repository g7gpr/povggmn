#!/bin/bash
cd $1
for f in *.fits
do 
convert -flip $f $(f%.*).bmp
done
