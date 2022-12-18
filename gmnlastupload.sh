#!/bin/bash

while read camera
do 
    ls /home/$camera/files/incoming/*.confirmed -lah | tail -n1
done  <~/cameras
