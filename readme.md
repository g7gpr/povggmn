# POVG GMN Utilities

## Introduction

This is a selection of utilities to assist with operating the network of meteor cameras in Western Australia.

## Descriptions

```
gmndiskuseage.sh Script to show the size of the users RMS_data directory. The cameraname is passed by an argument
gmndiskuseage.sh au0004

gmnforcereboot.sh Resets the state machine and forces a reboot

gmninitstates.sh Initialise the state machine

gmninstall.sh Install RMS for Linux PC

gmnmailer.sh Implements a simple mail dequeuer because some free email providers will not permit multiple concurrent logins

gmnmonitorstatus.sh Shows the states of all the cameras on the PC and the mail queue

gmnquota.sh Removes one captured file and archived file directory if the quota has been exceeeded for the current users

au0004@baldivis:/home/gmn/scripts/povggmn$ gmnquota.sh 200
Sleeping for 13 seconds
Space used is 133GB
Quota is 200GB
Underquota

au0004@baldivis:/home/gmn/scripts/povggmn$ gmnquota.sh 100
Sleeping for 11 seconds
Space used is 132GB
Quota is 100GB
Overquota
Next captured files directory to delete is /home/au0004/RMS_data/CapturedFiles/AU0004_20220901_122348_614809
Next archived files to delete is /home/au0004/RMS_data/ArchivedFiles/AU0004_20220711_120326_665638_detected.tar.bz2
Old space used was 133GB
New space used was 121GB
Space freed was 12GB

gmnrunexternalscript.sh Calls RMS.RunExternalScript with the path to the latest directories

gmnsetcameraparamsday.sh Sets IMX291 sensor to daytime settings
gmnsetcameraparamsnight.sh Sets IMX291 sensor to night time settings

gmnskyfitremote.sh This script gets the platepar and .config files from a remote machine, runs SkyFit2 on a local machine, then saves the updated files back to the remote machine

gmnskyfitremote.sh au0004@baldivis <password>

gmnupdateandrun.sh Updates RMS on the PC and starts capture

gmnwatchdog.sh This scripts controls the state machine, and must be called by each camera users crontab

shutdown This script is called instead of the normal system shutdown. This moves the state of a camera from running to stopped

```

## Installation instructions

- Configure bios to start the PC at 1600 local each day, probably will need to convert to UTC
- Install Debian from a USB key
- Create a user named after the observatory <observatory-name>. This user will manage activites
- Install the SSH server, and standard system utilities only
- Boot and shutdown, all futher work will be via ssh over local lan
- via ssh Login as the observatory user

- switch to the root user

- su
- and enter the superuser password

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

- As the gmn user

- mkdir -p ~/scripts

- cd ~/scripts

- Clone povggmnutils repository

- git clone https://www.github.com/g7gpr/povggmn

- Set PATH variable to repository location

- pico ~/.bashrc

- at the end add

- PATH=$PATH:/home/gmn/scripts/povggmn

- Save and exit then load the new .bashrc

- source ~/.bashrc

- switch to root

- su

- add PATH=$PATH:/home/gmn/scripts/povggmn to /.bashrc

- exit root user

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

- sudo adduser <camera-name>

- sudo usermod -aG sudo <camera-name>

- Log in to each camera and create the .ssh key for each user with an empty passphrase

- ssh-keygen -t rsa -m PEM 

- send the public part of the key to denis.vida@gmail.com

- Run gmninstall for each of the cameras consecutively

- enable passwordless sudo for shutdown 

- use sudo visudo to create a file with the name of each camera in the sudoers.d directory


- <camera-name> ALL=(ALL) NOPASSWD: /home/gmn/scripts/povggmn/shutdown
- <camera-name> ALL=(ALL) NOPASSWD: /usr/sbin/poweroff
- <camera-name> ALL=(ALL) NOPASSWD: /usr/sbin/reboot


- this will prevent the istrastream script from requiring manual password entry when it tries to call shutdown

- Setup cron jobs to run the state machine and the quota management

- rename the /usr/local/bin/shutdown so it cant be used

- add /home/gmn/scripts/povggmn: to the secure path in sudo visudo

- add mailinglist into gmn home directory


