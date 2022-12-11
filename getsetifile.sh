#!/bin/bash
ftp -i -n << EOF
open camsftp.seti.org
user "anonymous@seti.org" "anonymous"
cd incoming/AUS
get $1
EOF
