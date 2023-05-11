#! /bin/bash

if ! command -v git -v &> /dev/null
then
    echo -e "\n"
    echo "git could not be found. Install git to proceed."
    exit
fi

if ! command -v zsh -v &> /dev/null
then
    echo -e "\n"
    echo "zsh could not be found. Install zsh to proceed."
    exit
fi

if ! command -v fzf &> /dev/null
then
    echo -e "\n"
    echo "fzf could not be found. Install fzf to proceed."
    echo "Clone fzf using"
    echo "git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf"
    echo -e "\n"
    echo "Install fzf using"
    echo "~/.fzf/install"
    echo -e "\n"
    exit
fi

if [ -d ~/scripts ]
then
	cd ~/scripts/
	git pull
else
       git clone --depth=1 https://github.com/mchauras-linux/scripts.git \
	~/scripts
fi

~/scripts/mukesh-sync-vim-zsh-config.sh

chsh -s `which zsh`
