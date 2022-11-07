#!/bin/bash

#Upload to remote gmn server from data concentrator



#sleep for a random length of time to reduce the number of race conditions
#sleep $[ ( $RANDOM % 60 )  + 1 ]s

#check to see if remote server incoming space is free

echo $(sftp gmn.uwo.ca <<<"ls -lah files/*.bz2")





