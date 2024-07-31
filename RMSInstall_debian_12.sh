


rm_source() {

  echo Removing source directory
  cd ~
  sudo rm -rf ~/source
  echo Removed source directory
  sleep 1

}

rm_venv() {

  echo Removing venv
  cd ~
  rm -rf vRMS
  echo Removed venv
  sleep 1

}

populate_source_directory() {

  cd ~/source
  git clone https://github.com/python/cpython
	git clone https://github.com/FFmpeg/FFmpeg
  git clone https://github.com/g7gpr/RMS
  git clone https://github.com/opencv/opencv.git

}


create_source_directory() {

  echo Creating source directory
	mkdir -p ~/source
	echo Created source directory
	sleep 5
  populate_source_directory

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
  sleep 1

}

perform_apt_gets() {

  echo Getting packages
	sudo apt-get update
	sudo apt-get build-dep python3
  sudo apt-get install -y pkg-config
  sudo apt-get install -y build-essential gdb lcov pkg-config
  sudo apt-get install -y libbz2-dev libffi-dev libgdbm-dev libgdbm-compat-dev liblzma-dev
  sudo apt-get install -y libncurses5-dev libreadline6-dev libsqlite3-dev libssl-dev
  sudo apt-get install -y lzma lzma-dev tk-dev uuid-dev zlib1g-dev libmpdec-dev
	sudo apt-get install -y git mplayer libblas-dev libatlas-base-dev
  sudo apt-get install -y liblapack-dev at-spi2-core libopencv-dev libffi-dev libssl-dev socat ntp
  sudo apt-get install -y libxml2-dev libxslt-dev imagemagick cmake unzip
	sudo apt-get install -y autoconf automake build-essential cmake
	sudo apt-get install -y git-core
	sudo apt-get install -y libass-dev libfreetype6-dev libgnutls28-dev libmp3lame-dev libsdl2-dev libtool libvpx-dev libx264-dev libx265-dev
	sudo apt-get install -y libva-dev libvdpau-dev libvorbis-dev libxcb1-dev libxcb-shm0-dev libxcb-xfixes0-dev
	sudo apt-get install -y meson ninja-build pkg-config
	sudo apt-get install -y texinfo wget yasm
	sudo apt-get install -y zlib1g-dev nasm
	sudo apt-get install -y libx264-dev libx265-dev libnuma-dev libvpx-dev libfdk-aac-dev libopus-dev libdav1d-dev
	sudo apt-get install -y gstreamer1.0*
	sudo apt-get install -y gstreamer1.0-python3-dbg-plugin-loader
	sudo apt-get install -y gstreamer1.0-python3-plugin-loader
	sudo apt-get install -y ubuntu-restricted-extras
	sudo apt-get install -y libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev
  sudo apt-get install -y gstreamer1.0-plugins-good python3-pyqt5
  sudo apt-get install -y virtualenv
  sudo apt-get install -y libsqlite3-dev
  sudo apt-get install -y libbluetooth-dev
  sudo apt-get install -y libbz2-dev
  sudo apt-get install -y libdb-dev
  sudo apt-get install -y libexpat1-dev
  sudo apt-get install -y libffi-dev
  sudo apt-get install -y libgdbm-dev
  sudo apt-get install -y liblzma-dev
  sudo apt-get install -y libmpdec-dev
  sudo apt-get install -y libncursesw5-dev
  sudo apt-get install -y libreadline-dev
  sudo apt-get install -y libsqlite3-dev
  sudo apt-get install -y libssl-dev
  sudo apt-get install -y zlib1g-dev
  echo Got packages
  sleep 1

}



install_python() {

  cd ~/source/cpython
  git pull
  mkdir -p build
  cd build
  ../configure --with-pydebug --enable-optimizations --with-lto --with-computed-gotos
  make -j"$(nproc)"
  make altinstall
  cd ~/source

}


install_ffmpeg() {

  echo Installing ffmpeg
	cd ~/source/FFmpeg
	git pull
	source ~/vRMS/bin/activate
	mkdir -p build
	cd build
	../configure  --enable-shared --enable-gpl --enable-libx264 --enable-libx265 --enable-libvpx --enable-zlib
	make -j4
	sudo make install
	sudo ldconfig -v
  deactivate
	echo Installed ffmpeg
	sleep 1

}

install_openCV()  {

  echo Installing opencv
	cd ~/source/opencv
	git pull
	source ~/vRMS/bin/activate
  mkdir -p build
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
  cd RMS
  python setup.py install
  cd RMS

 }

install_CMNbinViewer() {

  cd ~/source/
  git clone https://github.com/CroatianMeteorNetwork/cmn_binviewer.git

}



#rm_source
#rm_venv
perform_apt_gets
if test -d ~/source/; then
    echo source directory exists
  else
    create_source_directory
  fi
install_python
#create_venv
#install_ffmpeg
#install_openCV
#install_RMS
