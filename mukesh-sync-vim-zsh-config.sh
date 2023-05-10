#! /bin/bash

CONFIG=~/scripts/configs

~/scripts/mukesh-upload-vim-zsh-config.sh

cd $CONFIG
git pull

cp $CONFIG/.vimrc ~/ 
cp $CONFIG/.zshrc ~/
cp $CONFIG/.zsh_aliases ~/
cp $CONFIG/.zsh_func ~/
cp $CONFIG/.p10k.zsh ~/


if [ ! -d ~/.oh-my-zsh ]
then
	git clone git@github.com:ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
fi
