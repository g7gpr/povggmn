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

echo
echo Filestoupload
more /home/*/RMS_data/*.inf | grep AU > ~/tmpfilestoupload
gmnuploadfilesizes.sh ~/tmpfilestoupload
echo
echo Number of files : $(wc -l ~/tmpfilestoupload)
echo

rm ~/tmpfilestoupload

cameraname=$(ls /home/gmn/cameras | head -n1)
latestlog=$(ls -t /home/$cameraname/RMS_data/logs/log* | head -n1)
starttimeline=$(grep "Next start" $latestlog | tail -n1)
starttime=${starttimeline#*$Next start time:}
starttimeseconds=$(date -u -d "${starttime%$*UTC}" +"%s")
timenowseconds=$(date +%s)
echo Start Time : $starttime : Seconds before next start : $(expr $starttimeseconds - $timenowseconds)
'
