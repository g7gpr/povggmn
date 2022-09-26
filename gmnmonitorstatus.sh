#!/bin/bash
watch -n1 '

echo Cameras
ls /home/gmn/cameras
echo
echo Systembooted
ls /home/gmn/states/systembooted
echo
echo Cameras updating
ls /home/gmn/states/camerasupdating
echo
echo Cameras ready to start
ls /home/gmn/states/camerasreadytostart 
echo
echo Cameras running 
ls /home/gmn/states/camerasrunning 
echo
echo Cameras stopped
ls /home/gmn/states/camerasstopped
echo
echo Runing final routines
ls /home/gmn/states/runningfinalroutines
echo
echo Ready for shutdown
ls /home/gmn/states/readyforshutdown
echo
echo Shutdown calls
ls /home/gmn/states/shutdowncalls
echo

echo
echo Outbox
echo 
ls /home/gmn/outbox/
'
