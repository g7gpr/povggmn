#!/bin/bash
username=$(whoami)
sftp gmn.uwo.ca <<<"ls -lah files/event_monitor"

