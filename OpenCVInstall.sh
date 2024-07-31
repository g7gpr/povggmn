rm_source() {
  cd ~
  sudo rm -rf ~/source
}

rm_venv() {
  cd ~
  rm -rf vRMS
}


create_source_directory() {
	mkdir -p ~/source
}

create_venv() {
  virtualenv vRMS
  source ~/vRMS/bin/activate
  pip install -r /home/gmn/scripts/povggmn/requirements.txt

}

perform_apt_gets() {
	sudo apt-get update
	sudo apt-get -y install autoconf automake build-essential cmake 
	sudo apt-get -y install git-core 
	sudo apt-get -y install libass-dev libfreetype6-dev libgnutls28-dev libmp3lame-dev libsdl2-dev libtool 
	sudo apt-get -y install libva-dev libvdpau-dev libvorbis-dev libxcb1-dev libxcb-shm0-dev libxcb-xfixes0-dev 
	sudo apt-get -y install meson ninja-build pkg-config 
	sudo apt-get -y install texinfo wget yasm 
	sudo apt-get -y install zlib1g-dev nasm
	sudo apt-get -y install libx264-dev libx265-dev libnuma-dev libvpx-dev libfdk-aac-dev libopus-dev libdav1d-dev
	sudo apt install -y gstreamer1.0*
	sudo apt install -y gstreamer1.0-python3-dbg-plugin-loader
	sudo apt install -y gstreamer1.0-python3-plugin-loader
	sudo apt install -y ubuntu-restricted-extras
	sudo apt install -y libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev
  sudo apt install -y gstreamer1.0-plugins-good python3-pyqt5
}

install_ffmpeg() {
	cd ~/source
	rm ffmpeg-5.0.tar.bz2
	wget -O ffmpeg-5.0.tar.bz2 "https://www.ffmpeg.org/releases/ffmpeg-5.0.1.tar.bz2"
	tar -xvf ffmpeg-5.0.tar.bz2
	cd ffmpeg-5.0.1
	./configure  --enable-shared --enable-gpl --enable-libx264 --enable-libx265 --enable-libvpx --enable-zlib
	sudo make -j4
	sudo make install
	sudo ldconfig -v
}

install_openCV()  {
	cd ~/source
	rm opencv.zip
	wget -O opencv.zip https://github.com/opencv/opencv/archive/4.x.zip
	unzip opencv.zip
	mkdir -p build
	cd build
	cmake ../opencv-4.x	
	cmake --build .  --config Release -j4
	sudo make install
}

install_RMS() {
  cd ~/source
  git clone https://ghithub.com/g7gpr/RMS
  cd RMS
  python setup.py install
 }

install_CMNbinViewer() {
  cd ~/source/
  git clone https://github.com/CroatianMeteorNetwork/cmn_binviewer.git
}


echo "Removing source directory"
rm_source
sleep 3
echo "Removing venv"
rm_venv
echo "Get Packages"
perform_apt_gets
create_source_directory
sleep 3
echo "Creating venv"
create_venv
sleep 3

install_ffmpeg
install_openCV
install_RMS
