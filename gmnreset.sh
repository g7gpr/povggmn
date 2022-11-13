#!/bin/bash
git remote rm origin
git remote add origin https://github.com/CroatianMeteorNetwork/RMS
git fetch origin uploadfix
git reset --hard origin/uploadfix
git branch --set-upstream-to=origin/uploadfix uploadfix

#git clean -xdf
