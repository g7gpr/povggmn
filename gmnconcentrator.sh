#!/bin/bash
sudo watch -n10 '
echo File in transit 
echo 
ls /home/*/files/incoming/.*.bz2* -lah  
echo File in partial 
echo 
ls /home/*/files/incoming/partial/* -lah  
echo 
echo Files arrived 
echo 
for user in /home/au*; do  ls $user/files/incoming/*.bz2 | tail -n1 ; done'


