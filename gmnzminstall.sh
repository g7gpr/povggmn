#!/bin/bash

#Change to the home directory
cd ~
mkdir zm
cd zm
sudo apt update
sudo apt-get install apache2 mariadb-server mariadb-client php gdebi devscripts -y
wget https://raw.githubusercontent.com/ZoneMinder/ZoneMinder/master/utils/do_debian_package.sh
chmod a+x do_debian_package.sh
./do_debian_package.sh --snapshot=stable --type=local
sudo gdebi zoneminder_*_amd64.deb
sudo systemctl enable zoneminder.service
sudo a2enconf zoneminder 
sudo a2enmod  rewrite
sudo a2enmod cgi
sudo systemctl restart apache2
sudo systemctl restart zoneminder
