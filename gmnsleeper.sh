#!/bin/bash

# Time Arithmetic
SUNSET=`hdate -s -l32.3 -L115.8 | tail -n1 | cut -d' ' -f2`

TIME1=`date +%H:%M:%S`
TIME2=$SUNSET

echo Time now $TIME1
echo Sunset time $TIME2

# Convert the times to seconds from the Epoch
SEC1=`date +%s -d ${TIME1}`
SEC2=`date +%s -d ${TIME2}`

# Use expr to do the math, let's say TIME1 was the start and TIME2 was the finish
DIFFSEC=`expr ${SEC2} - ${SEC1}`

echo Start ${TIME1}
echo Finish ${TIME2}

echo Sleep for ${DIFFSEC} seconds.

# And use date to convert the seconds back to something more meaningful
echo Took `date +%H:%M:%S -ud @${DIFFSEC}`
