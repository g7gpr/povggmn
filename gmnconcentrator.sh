#!/bin/bash
sudo watch -n10 '
echo File in transit 
echo 
ls /home/*/files/incoming/.*.bz2* -lah  
echo File in partial 
echo 
ls /home/*/files/incoming/partial/* -lah  
echo 
echo Last confirmed file
echo 
for user in /home/au*
do  
  last_bz2_file=$(ls $user/files/incoming/*.bz2 | tail -n1)
  last_confirmed_file=$(ls $user/files/incoming/*.bz2.confirmed | tail -n1)
  last_confirmed_file_without_extension=${last_confirmed_file%.*}
  #echo $last_bz2_file
  #echo $last_confirmed_file
  #echo $last_confirmed_file_without_extension
  if [ "$last_confirmed_file_without_extension" != "$last_bz2_file" ]; then
  echo $last_confirmed_file_without_extension
fi
done
echo
ls /home/*/.uploaderrunning -lah

'


