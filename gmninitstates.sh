#!/bin/bash
#This script intialises the state machine
rm -rf /home/gmn/states/*
mkdir -p /home/gmn/states/camerasreadytostart
mkdir -p /home/gmn/states/camerasrunning
mkdir -p /home/gmn/states/camerasstopped
mkdir -p /home/gmn/states/readyforshutdown
mkdir -p /home/gmn/states/shutdowncalls
mkdir -p /home/gmn/states/systembooted
mkdir -p /home/gmn/states/camerasupdating
mkdir -p /home/gmn/states/runningfinalroutines
mkdir -p /home/gmn/states/runningfinalroutinesstation
cp /home/gmn/cameras/* /home/gmn/states/systembooted/
cd /home/gmn/states
chmod -R ugo+rwx * 

