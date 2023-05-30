#!/bin/bash
mkdir -p /tmp/$(whoami)/
/home/gmn/scripts/povggmn/sftpdirlist.sh  >  /tmp/$(whoami)/remotedirlist
sed -i -e 1,2d /tmp/$(whoami)/remotedirlist 
cd ~/files/incoming
ls *.bz2 > /tmp/$(whoami)/localdirlist
diff -w /tmp/$(whoami)/localdirlist /tmp/$(whoami)/remotedirlist | grep ">"
