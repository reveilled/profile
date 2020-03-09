#! /bin/bash
cp .vimrc ~
cp .tmux.conf ~
cp .bashrc ~
cp .gdbinit ~
cp -r utils/* ~

#machine setup (Fresh UBUNTU)
sudo apt install vim htop python-pip python3-pip llvm libssl-dev cmake openssl libcurl4-openssl-dev build-essential git python-lzma python-crypto python3-crypto libqt4-opengl python-opengl python-qt4 python-qt4-gl python-numpy python-scipy libqt4-opengl python3-opengl python3-pyqt4 python3-pyqt4.qtopengl python3-numpy python3-scipy mtd-utils gzip bzip2 tar arj lhasa p7zip p7zip-full cabextract cramfsprogs squashfs-tools sleuthkit default-jdk lzop srecord zlib1g-dev liblzma-dev liblzo2-dev liblzo2-dev python-lzo xclip

pip install capstone keystone-engine ropper unicorn pyqtgraph
pip3 install capstone keystone-engine ropper unicorn pyqtgraph

#get gef
cp gef/gef.py ~/.gdbinit-gef.py

#get binwalk
pushd binwalk
sudo ./deps.sh
sudo python setup.py install
popd

pushd ~/shell-loader
make
popd
