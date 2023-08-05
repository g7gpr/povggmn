#!/bin/bash

#for cam in /home/au*

#do
#sudo su $(basename $cam) -c "whoami"
#sudo su $(basename $cam) -c "mkdir -p /home/event_monitor/files/archives; cd /home/event_monitor/files/archives;  sftp gmn.uwo.ca <<<'get -a files/event_monitor/*.bz2'"
#done

mkdir -p /home/event_monitor/files/archives/
chmod +777 /home/event_monitor/files/archives/

for cam in /home/au*
do
rsync -v $cam/files/event_monitor/*.bz2 /home/event_monitor/files/archives;
done

