#!/bin/bash
sudo watch -n10 '
echo File in transit 
echo 
ls /home/*/files/incoming/.*.bz2* -lahS   
echo File in partial 
echo 
ls /home/*/files/incoming/partial/* -lah  

echo
echo Next file to upload
echo

for user in /home/au*
do  
  #echo $user
  last_bz2_file=$(ls $user/files/incoming/*.bz2  | tail -n1)

  last_uploaded_file=$(ls $user/files/incoming/*.uploaded 2>/dev/null | tail -n1)
  last_uploaded_file_without_extension=${last_uploaded_file%.*}
  last_confirmed_file=$(ls $user/files/incoming/*.bz2.confirmed | tail -n1)
  last_confirmed_file_without_extension=${last_confirmed_file%.*}

  #echo $last_uploaded_file_without_extension
  #echo $last_bz2_file
  #echo $last_uploaded_file
  #echo $last_bz2_file_without_extension
  if [ "$last_uploaded_file_without_extension" != "$last_bz2_file" ]; then
  if [ "$last_confirmed_file_without_extension" != "$last_bz2_file" ]; then
  if [ ! -f $last_bz2_file.uploading ]; then

  echo $(basename $last_bz2_file) $(stat $last_bz2_file -c%w)
fi
fi
fi
done

echo
echo Files uploading
echo

for user in /home/au*
do
  #echo $user
  last_bz2_file=$(ls $user/files/incoming/*.bz2  | tail -n1)
  last_file_uploading=$(ls $user/files/incoming/*.uploading 2>/dev/null | tail -n1)
  #echo $last_uploaded_file
  last_file_uploading_without_extension=${last_file_uploading%.*}
  if [ "$last_file_uploading_without_extension" !=  "" ]; then
   echo $(basename $last_file_uploading_without_extension)  $(stat $last_file_uploading -c%w)
  fi
done



echo
echo Last uploaded file
echo

for user in /home/au*
do  
  #echo $user
  last_bz2_file=$(ls $user/files/incoming/*.bz2  | tail -n1)
  last_uploaded_file=$(ls $user/files/incoming/*.uploaded 2>/dev/null | tail -n1)
  #echo $last_uploaded_file
  last_uploaded_file_without_extension=${last_uploaded_file%.*}
  #echo $last_uploaded_file_without_extension
  #echo $last_bz2_file
  #echo $last_uploaded_file
  #echo $last_uploaded_file_without_extension
  if [ "$last_uploaded_file_without_extension" != "" ]; then # "$last_bz2_file" ]; then
  echo $(basename $last_uploaded_file_without_extension) $(stat -c%w $last_uploaded_file)
fi
done

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
  echo $(basename $last_confirmed_file_without_extension) $(stat -c%w $last_confirmed_file_without_extension.confirmed)
done





echo
ls /home/*/.uploaderrunning -lah

'


