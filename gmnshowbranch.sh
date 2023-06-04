#!/bin/bash
for u in /home/au*; 
do sudo su $(basename $u) -c "cd ~/source/RMS ; git branch" 
done
