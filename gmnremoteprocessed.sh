#!/bin/bash
username=$(whoami)
sftp gmn.uwo.ca <<<"ls -lah files/processed/*.bz2"

