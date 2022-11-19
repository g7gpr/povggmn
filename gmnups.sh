#!/bin/bash
PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/home/gmn/scripts/povggmn

more /home/au000*/RMS_data/FILES_TO_UPLOAD.inf | grep detected >  /home/gmn/uploads.new
/usr/bin/diff /home/gmn/uploads.new /home/gmn/uploads.old > /home/gmn/uploads.diff
cp   /home/gmn/uploads.new /home/gmn/uploads.old

difflines=$(wc -l /home/gmn/uploads.diff | cut -d" " -f1 )
filestosend=$(more /home/gmn/uploads.new | grep detected | wc -l)
echo "There are $filestosend files to be uploaded." 
echo >>  /home/gmn/uploader.log
MBtosend=$(gmnuploadfilesizes.sh ~/uploads.new | cut -d" " -f5 | paste -sd+ | bc -l)
echo $MBtosend MB to be sent             




if [ "$difflines" -ne "0" ];
then
echo "Change"
echo "Modifcation detected at " $(date -u) >> /home/gmn/uploader.log
echo "There are $filestosend files to be uploaded." >> /home/gmn/uploader.log
echo au000u files : $(more /home/gmn/uploads.new | grep detected | grep AU000U | wc -l) >> /home/gmn/uploader.log
echo au000v files : $(more /home/gmn/uploads.new | grep detected | grep AU000V | wc -l) >> /home/gmn/uploader.log
echo au000w files : $(more /home/gmn/uploads.new | grep detected | grep AU000W | wc -l) >> /home/gmn/uploader.log
echo au000x files : $(more /home/gmn/uploads.new | grep detected | grep AU000X | wc -l) >> /home/gmn/uploader.log
echo au000y files : $(more /home/gmn/uploads.new | grep detected | grep AU000Y | wc -l) >> /home/gmn/uploader.log
echo au000z files : $(more /home/gmn/uploads.new | grep detected | grep AU000Z | wc -l) >> /home/gmn/uploader.log

echo                                                >> /home/gmn/uploader.log

echo "Files to be uploaded are:"           >> /home/gmn/uploader.log
gmnuploadfilesizes.sh ~/uploads.new        >> /home/gmn/uploader.log
echo					   >> /home/gmn/uploader.log
echo $(date -u) $MBtosend MB to be uploaded           >> /home/gmn/uploader.log
echo					   >> /home/gmn/uploader.log

echo "**********************************************************"          >> /home/gmn/uploader.log
echo "**********************************************************"          >> /home/gmn/uploader.log
more /home/au000u/gitlog 								    >> /home/gmn/uploader.log
more /home/au000v/gitlog 								    >> /home/gmn/uploader.log
more /home/au000w/gitlog 								    >> /home/gmn/uploader.log
more /home/au000x/gitlog 								    >> /home/gmn/uploader.log
more /home/au000y/gitlog 								    >> /home/gmn/uploader.log
more /home/au000z/gitlog 								    >> /home/gmn/uploader.log
else
echo "No change"
fi

