#!/bin/bash
for cam in /home/au*
do
sudo su $(basename $cam) -c "whoami"
sudo su $(basename $cam) -c "sftp gmn.uwo.ca <<<'rm files/event_monitor/*.bz2'"
done
