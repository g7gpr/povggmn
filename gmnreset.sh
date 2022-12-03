#!/bin/bash
git remote rm origin
git remote add origin https://github.com/CroatianMeteorNetwork/RMS
git fetch origin master
git reset --hard origin/master
git branch --set-upstream-to=origin/master master
git checkout master
cp ~/.rms_backup/.config  ~/source/RMS/
cp ~/.rms_backup/mask.bmp ~/source/RMS/

#git clean -xdf
