#!/bin/bash
#This script intialises the state machine

rm /home/gmn/states/camerasreadytostart/*
rm /home/gmn/states/camerasrunning/*
rm /home/gmn/states/camerasstopped/*
rm /home/gmn/states/readyforshutdown/*
rm /home/gmn/states/shutdowncalls/*
rm /home/gmn/states/systembooted/*
rm /home/gmn/states/camerasupdating/*
cp /home/gmn/cameras/* /home/gmn/states/systembooted/


