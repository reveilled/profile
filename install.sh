#! /bin/bash
cp .vimrc ~
cp .tmux.conf ~
cp .bashrc ~
cp .gdbinit ~
cp -r utils/* ~

#machine setup (Fresh UBUNTU)
sudo apt install vim htop python-pip-whl python3-pip llvm libssl-dev cmake openssl libcurl4-openssl-dev build-essential git python-crypto python3-crypto python-opengl python-numpy libqt5opengl5 python3-opengl python3-numpy python3-scipy mtd-utils gzip bzip2 tar arj lhasa p7zip p7zip-full cabextract cramfsswap squashfs-tools sleuthkit default-jdk lzop srecord zlib1g-dev liblzma-dev liblzo2-dev xclip tmux screen minicom nasm xxd #cramfsprogs

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

git config --global core.editor "vim"
