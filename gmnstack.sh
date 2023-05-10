#!/bin/bash
cd $1
source ~/vRMS/bin/activate
cd ~/source/RMS
python -m Utils.StackFFs -x $1 jpg
mv $1/*stack*.jpg $1/$2_stack.jpg
