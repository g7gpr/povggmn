#!/bin/bash
lasttrajdate=$(wget https://globalmeteornetwork.org/data/traj_summary_data/daily/traj_summary_latest_daily.txt -nv -O - | grep $1 | tail -n1 | cut -d";" -f3)
lasttrajectoryseconds=$(date --date "$lasttrajdate" +%s)
secondsnow=$(date +%s)
secondselapsed=$(($secondsnow - $lasttrajectoryseconds))
hourselapsed=$(($secondselapsed / 3600))
echo GMN calculations running $hourselapsed hours behind real time
