#!/bin/bash
echo Moving to g7gpr/RMS
cd ~/source/RMS
mkdir -p /tmp/gmnbackup/$(whoami)
cp .config /tmp/gmnbackup/$(whoami)/.
cp platepar_cmn2010.cal /tmp/gmnbackup/$(whoami)/.
cp mask.bmp /tmp/gmnbackup/$(whoami)/.
cd ~/source
mv ~/source/RMS ~/source/RMS_backup
git clone https://github.com/g7gpr/RMS
cd ~/source/RMS
cp /tmp/gmnbackup/$(whoami)/.config .
cp /tmp/gmnbackup/$(whoami)/platepar_cmn2010.cal .
cp /tmp/gmnbackup/$(whoami)/mask.bmp .
Scripts/RMS_Update.sh
git remote -v

