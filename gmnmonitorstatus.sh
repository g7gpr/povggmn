#!/bin/bash
watch -n60 '

#echo Cameras
#ls /home/gmn/cameras
#echo
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
echo Runing final routines station wide
ls /home/gmn/states/runningfinalroutinesstation
echo
echo Shutdown calls
ls /home/gmn/states/shutdowncalls
echo

echo
echo Outbox
ls /home/gmn/outbox/

'
