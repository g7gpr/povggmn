#!/bin/bash
cd /home/event_monitor/files/
for fpath in /home/event_monitor/files/archives/*.bz2
do 
	f=$(basename $fpath)

	dirdate=${f:7:8}
	dirtime=${f:16:6}
	cam=${f:0:6}
	echo $dirdate $dirtime $cam
	mkdir -p $dirdate
	cd $dirdate
	mkdir -p $dirtime
	cd $dirtime
	tar -xf ../../archives/$f
	mv *stack*.jpg ..
	mv *.mp4 ..
	cd ..
	cd ..
done

# Make SkyMaps
echo Iterating folders
source /home/gmn/vRMS/bin/activate

for datepath in /home/event_monitor/files/*
do
   if [ $(basename($datepath)) != archives ] ; then
   echo $datepath

   for timepath in $datepath/*
   do
      echo $timepath
      for network in $timepath/*
      do
         for group in $network/*
         do
	    echo $group
	    cd /home/gmn/source/RMS/
	    python -m Utils.FOVSkyMap -n $group
	    for camera in $group/*
            do
                cp $camera/*stack*.jpg $group
            done
         done
     done
  done
  fi
done

rsync -av --delete /home/event_monitor/files/ david@192.168.1.230:/var/www/html/data/events
