#! /bin/bash

CONFIG=~/scripts/configs

cp ~/.vimrc $CONFIG 
cp ~/.zshrc $CONFIG 
cp ~/.zsh_func $CONFIG
cp ~/.zsh_aliases $CONFIG
cp ~/.p10k.zsh $CONFIG

cd ~/scripts

if [ -f ~/.zshrc ] 
then
	git add configs/.vimrc configs/.zshrc configs/.zsh_func configs/.p10k.zsh configs/.zsh_aliases
	git commit -m "Updated vim and zsh config"
	echo "\n\nPushing All configs to scripts repo\n\n"
	git push
fi
