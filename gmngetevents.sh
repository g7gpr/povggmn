#!/bin/bash
username=$(whoami)
sftp gmn.uwo.ca <<<"get files/event_monitor/*.bz2"

