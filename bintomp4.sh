#!/bin/bash
source ~/vRMS/bin/activate
cd ~/source/RMS
python -m Utils.FRbinViewer -x -fmp4 $1
