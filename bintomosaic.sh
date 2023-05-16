#!/bin/bash
source ~/vRMS/bin/activate
cd ~/source/RMS
for f in $1/*.bin
do
echo $f
python -m Utils.FRbinMosaic $f
done
