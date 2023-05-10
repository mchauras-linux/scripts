#! /bin/bash

CONFIG=~/scripts/configs

cd $CONFIG
git pull

cp $CONFIG/.vimrc ~/ 
cp $CONFIG/.zshrc ~/
cp $CONFIG/.zsh_func ~/
cp $CONFIG/.p10k.zsh ~/
cp $CONFIG/.oh-my-zsh ~/

