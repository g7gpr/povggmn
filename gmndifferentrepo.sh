#!/bin/bash
echo Moving to g7gpr/RMS
cd ~/source/RMS
mkdir -p ~/gmnbackup/$(whoami)
cp .config ~/gmnbackup/$(whoami)/.
cp platepar_cmn2010.cal ~/gmnbackup/$(whoami)/.
cp mask.bmp  ~/gmnbackup/$(whoami)/.
cd ~/source
mv ~/source/RMS ~/source/RMS_backup
git clone https://github.com/CroatianMeteorNetwork/RMS
cd ~/source/RMS
Scripts/RMS_Update.sh
git remote set-url origin https://github.com/CroatianMeteorNetwork/RMS
git remote -v
rm ~/source/RMS/.config
rm ~/source/RMS/mask.bmp
rm ~/source/RMS/platepar_cmn2010.cal
git checkout eventmonitor
cp ~/gmnbackup/$(whoami)/.config .
cp ~/gmnbackup/$(whoami)/mask.bmp . 
cp ~/gmnbackup/$(whoami)/platepar_cmn2010.cal . 


git branch
