#!/bin/bash

#This script sends mails from the outbox


if [ "$(ls -A /home/gmn/outbox)" ]; then

filetosend=$(ls /home/gmn/outbox/*track*.jpg | head -n1)
logger -s -t $filetosend sent
echo $filetosend
echo Trackstack $filetosend attached.  | mutt  -s "Trackstack" "$(</home/gmn/mailinglist)" -a $filetosend
rm -f $filetosend

else

logger -s -t Nothing to send

fi
