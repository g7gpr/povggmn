#!/bin/bash
cd ~/source
rm -rf RMS
rsync -avzh --progress rms@192.168.1.241:source/RMS .
cd RMS
Scripts/RMS_update.sh