create_source_directory() {

	mkdir -p ~/source
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

create_source_directory
perform_apt_gets
install_ffmpeg
install_openCV
 
