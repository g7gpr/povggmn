#!/bin/bash
echo Moving to g7gpr/RMS
cd ~/source/RMS
mkdir -p ~/gmnbackup/$(whoami)
cp .config ~/gmnbackup/$(whoami)/.
cp platepar_cmn2010.cal ~/gmnbackup/$(whoami)/.
cp mask.bmp  ~/gmnbackup/$(whoami)/.
cd ~/source
mv ~/source/RMS ~/source/RMS_backup
git clone https://github.com/g7gpr/RMS
cd ~/source/RMS
cp ~/gmnbackup/$(whoami)/.config .
cp ~/gmnbackup/$(whoami)/platepar_cmn2010.cal .
cp ~/gmnbackup/$(whoami)/mask.bmp .
Scripts/RMS_Update.sh
git remote -v

