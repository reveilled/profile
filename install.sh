cp .vimrc ~
cp .tmux.conf ~
cp .bashrc ~
cp .gdbinit ~
cp -r utils/* ~

pushd ~/shell-loader
make
popd
