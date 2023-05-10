#! /bin/bash

CONFIG=~/scripts/configs

cp ~/.vimrc $CONFIG 
cp ~/.zshrc $CONFIG 
cp ~/.zsh_func $CONFIG
cp ~/.zsh_aliases $CONFIG
cp ~/.p10k.zsh $CONFIG
cp -rf ~/.oh-my-zsh $CONFIG

cd ~/scripts

git add configs/.vimrc configs/.zshrc configs/.zsh_func configs/.p10k.zsh configs/.oh-my-zsh configs/.zsh_aliases

git commit -m "Updated vim and zsh config"

git push
