# POVG GMN Utilities

## Introduction

This is a selection of utilities to assist with operating the network of meteor cameras in Western Australia.

## Descriptions

```
examplecrontab		old way of starting RMS_Capture. No longer in use
gmnforcereboot.sh	resets the camera management and reboots the computer
gmnmonitorstatus.sh	shows the status of the lockfiles
gmnreboot.sh		if every camera has requested a shutdown then reboot the computer
gmnupdateandrun.sh	RMS_Update.sh and RMS_StartCapture.sh
readme.md		this file
gmndiskuseage.sh	shows the amount of space used by a cameras RMS_data directory
gmninstall.sh		the installation scripts by 
gmnquota.sh		each time this is called, if the disk use is above the quota in GB passed as parameter
                        one Capture directory and one Archive directory is deleted
gmnskyfitremote.sh	pulls the platepar, .config and some of the most recent FITS files from a remote machine
			runs SkyFit locally and when skyfit terminates, puts the files back again. Also
			makes backups and stores them in date stamped folders
gmnwatchdog.sh		checks that a camera has announced that it has started, if it has not, then it starts the camera
			runs from a cameras own cron
pinout			the pinouts for the headers on the camera modules
shutdown		the file which replaces the system shutdown command. This allows iStraStream to call shutdown safely
			and marks that the camera has finished to get ready for a reboot




```

## Installation instructions

- Configure bios to start the PC at 1600 local each day, probably will need to convert to UTC
- Install Debian from a USB key
- Create a user named after the observatory <observatory-name>. This user will manage activites
- Install the SSH server, and standard system utilities only
- Boot and shutdown, all futher work will be via ssh over local lan
- via ssh Login as the observatory user
- su
- 

`apt-get install -y sudo`

- Give the observatory user sudo rights

`sudo usermod -aG sudo <observatory-name>`
`sudo reboot`

- Login as <observatory-name>
- Add a user gmn and give sudo rights
- sudo adduser gmn
- sudo usermod -aG sudo gmn

`sudo apt-get install screen ntp openvpn git gpsd-clients gpsd gpsd-clients -y`

- Install credentials for openvpn if this is required

- Move over to the cellular network modem if applicable

- Prove openvpn is working if applicable

- The rest of the work can be done remotely

- Clone povggmnutils repository

- Set PATH variable to repository location

- pico ~/.bashrc

- at the end add

- PATH=$PATH:/home/gmn/scripts/povggmn

- source ~/.bashrc

- also do this by su and edit  /.bashrc

- Run gmninstall in the <observatory-name> account (this will take a long time)

- Whilst gmninstall is in progress if required install the GPS dongle timekeeping

- from https://www.rapid7.com/blog/post/2015/07/27/adding-a-gps-time-source-to-ntpd/

- sudo pico /etc/default/gpsd

- Change GPSD_OPTIONS="" to GPSD_OPTIONS="-n"

- sudo pico /etc/ntp.conf

- add

```
# GPS Serial data reference
server 127.127.28.0 minpoll 4 maxpoll 4
fudge 127.127.28.0 time1 0.0 refid GPS

# GPS PPS reference
server 127.127.28.1 minpoll 4 maxpoll 4 prefer
fudge 127.127.28.1 refid PPS
```

- and then

- sudo systemctl restart ntp

- Unplug the GPS dongle and plug back in

- Create users for each of the cameras with sudo priviledge

- Create the .ssh key for each user with an empty passphrase

- ssh-keygen -t rsa -m PEM 

- send the public part of the key to denis.vida@gmail.com

- Run gmninstall for each of the cameras

- enable passwordless sudo for shutdown 

- use sudo visudo to create a file with the name of each camera in the sudoers.d directory

- <camera-name> ALL=(ALL) NOPASSWD: /home/gmn/scripts/povggmn/shutdown

- this will prevent the istrastream script from requiring manual password entry when it tries to call shutdown

- Setup cron jobs to launch RMS_Update; RMS_StartCapture

- Setup cron jobs for quota management

- Setup the autoshutdown system

- rename the /usr/local/bin/shutdown so it cant be used

- edit the secure path in sudo visudo

- Allow each user to run shutdown without sudo

