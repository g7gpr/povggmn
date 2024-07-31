rm_source() {
  echo Removing source directory
  cd ~
  sudo rm -rf ~/source
  echo Removed source directory
  sleep 5
}

rm_venv() {
  echo Removing venv
  cd ~
  rm -rf vRMS
  echo Removed venv
  sleep 5
}


create_source_directory() {
  echo Creating source directory
	mkdir -p ~/source
	echo Created source directory
	sleep 5
}

create_venv() {
  echo Creating venv
  virtualenv vRMS
  source ~/vRMS/bin/activate
  pip install -U pip setuptools
  pip install numpy
  pip install Pillow
  pip install gitpython cython pyephem astropy
  pip install scipy==1.8.1
  pip install paramiko==2.8.0
  pip install matplotlib
  pip install imreg_dft
  pip install configparser==4.0.2
  pip install imageio==2.6.1
  pip install pyfits
  pip install PyQt5
  echo Created venv
  sleep 5
}

perform_apt_gets() {
  echo Getting packages
	sudo apt-get update
	sudo apt-get install -y git mplayer libblas-dev libatlas-base-dev
  sudo apt-get install -y liblapack-dev at-spi2-core libopencv-dev libffi-dev libssl-dev socat ntp
  sudo apt-get install -y libxml2-dev libxslt-dev imagemagick ffmpeg cmake unzip
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
  sudo apt-get -y install virtualenv
  sudo apt-get -y install libsqlite3-dev
  echo Got packages
  sleep 5
}



install_python() {

  cd ~/source
  source ~/vRMS/bin/activate
  wget -o https://www.python.org/ftp/python/3.12.4/Python-3.12.4.tgz
  tar xf Python-3.12.4
  cd Python-3.12.4
  ./configure --prefix=/opt/python/3.12.4/ --enable-optimizations --with-lto --with-computed-gotos --with-system-ffi
  make -j"$(nproc)"
  make altinstall

}


install_ffmpeg() {
  echo Installing ffmpeg
	cd ~/source
	source ~/vRMS/bin/activate
	rm ffmpeg-5.0.tar.bz2
	wget -O ffmpeg-5.0.tar.bz2 "https://www.ffmpeg.org/releases/ffmpeg-5.0.1.tar.bz2"
	tar xf ffmpeg-5.0.tar.bz2
	cd ffmpeg-5.0.1
	./configure  --enable-shared --enable-gpl --enable-libx264 --enable-libx265 --enable-libvpx --enable-zlib
	sudo make -j4
	sudo make install
	sudo ldconfig -v
	deactivate
	echo Installed ffmpeg
	sleep 5
}

install_openCV()  {
  echo Installing opencv
	cd ~/source
	source ~/vRMS/bin/activate
  git clone https://github.com/opencv/opencv.git
  cd opencv/
  git checkout 4.7.0
  mkdir build
  cd build
  cmake -D CMAKE_BUILD_TYPE=RELEASE \
        -D INSTALL_PYTHON_EXAMPLES=ON \
        -D INSTALL_C_EXAMPLES=OFF \
        -D PYTHON_EXECUTABLE=$(which python3) \
        -D BUILD_opencv_python2=OFF \
        -D CMAKE_INSTALL_PREFIX=$(python3 -c 'import sys; print(sys.prefix)') \
        -D PYTHON3_EXECUTABLE=$(which python3) \
        -D PYTHON3_INCLUDE_DIR=$(python3 -c 'from distutils.sysconfig import get_python_inc; print(get_python_inc())') \
        -D PYTHON3_PACKAGES_PATH=$(python3 -c 'from distutils.sysconfig import get_python_lib; print(get_python_lib())') \
        -D WITH_GSTREAMER=ON \
        -D BUILD_EXAMPLES=ON ..
  sudo make -j$(nproc)

  deactivate
  echo Installed OpencV
  sleep 5
}

install_RMS() {
  cd ~/source
  git clone https://github.com/g7gpr/RMS
  python setup.py install
  cd RMS

 }

install_CMNbinViewer() {
  cd ~/source/
  git clone https://github.com/CroatianMeteorNetwork/cmn_binviewer.git
}



rm_source
rm_venv
perform_apt_gets
create_source_directory
install_python
create_venv
install_ffmpeg
install_openCV
install_RMS
