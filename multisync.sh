#!/bin/bash
for cam in /home/gmn/cameras/*
 do
 sudo su $(basename $cam) -c "gmnsshrsync.sh"
done