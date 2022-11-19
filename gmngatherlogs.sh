
#!/bin/bash
dstr=$(date -u "+%Y%m%d")
echo Gathering logs for $1
mkdir ~/tmp/
cd ~/tmp/
mkdir $1
cd $1
cp /home/au000*/RMS_data/logs/*$1*.log .
cp /home/gmn/uploader.log . 
cd ..
tar cvfz $1.tar.gz $1
echo "Logfiles" | mutt -s "Logfiles $1" "g7gpr@outlook.com,davidrollinson@hotmail.com" -a $1.tar.gz
