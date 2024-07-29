#!/bin/bash

for camera in /home/gmn/cameras/*
do
  echo $(basename $camera)
  platepar_path="/home/$(basename $camera)/source/RMS/platepar_cmn2010.cal"
  mkdir -p /home/gmn/platepars/$(basename $camera)/
  cp $platepar_path /home/gmn/platepars/$(basename $camera)/
done

echo $command_string