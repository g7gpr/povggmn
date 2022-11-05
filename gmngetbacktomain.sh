#!/bin/bash
cd ~/source/RMS
cp ~/source/RMS/.config ~/.configtmp
cp ~/source/RMS/mask.bmp ~/masktmp.bmp

git stash
Scripts/RMS_Update.sh
cp ~/.configtmp ~/source/RMS/.config
cp ~/masktmp.bmp ~/source/RMS/masktmp.bmp

