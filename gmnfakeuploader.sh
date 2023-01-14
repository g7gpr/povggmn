#!/bin/bash

#set all files as uploaded


for file in ~/files/incoming/*.bz2
do



if [ -f $file.confirmed ] ;
then
echo $file.confirmed exists
else
echo $file.confirmed does not exist
touch $file.confirmed
fi

done
