#!/bin/bash


starttimeseconds=$(git show -s --format=%ct)
timenowseconds=$(date +%s)
echo $(expr $timenowseconds - $starttimeseconds)

