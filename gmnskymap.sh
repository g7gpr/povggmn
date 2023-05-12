#!/bin/bash
source ~/vRMS/bin/activate
cd ~/source/RMS
python -m Utils.FOVSkyMap -n $1
