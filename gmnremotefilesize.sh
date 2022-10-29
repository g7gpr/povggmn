#!/bin/bash
username=$(whoami)
sftp gmn.uwo.ca <<<"ls -lah files/*.bz2"
echo "Local size"
ls -lah /home/$username/RMS_data/ArchivedFiles/*.bz2 | tail  -n1

