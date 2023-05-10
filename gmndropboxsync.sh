#!/bin/bash
python ~/dropbox.py start &
#sleep for slightly less than 10 minutes
sleep 550 
python ~/dropbox.py stop
