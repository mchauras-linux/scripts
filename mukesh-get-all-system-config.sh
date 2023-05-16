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

if ! command -v usermod -v &> /dev/null
then
    echo -e "\n"
    echo "usermod could not be found. Install usermod to proceed."
    exit
fi

if ! command -v fzf &> /dev/null
then
    echo -e "\n"
    echo "fzf could not be found. Install fzf to proceed."
    echo "Clone fzf using"
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    echo -e "\n"
    echo "Install fzf using"
    ~/.fzf/install
    echo -e "\nRestart Terminal, In case of SSH, disconnect and connect again."
    exit 1
fi

if [ -d ~/scripts ]
then
	cd ~/scripts/
	git pull
else
       git clone --depth=1 https://github.com/mchauras-linux/scripts.git \
	~/scripts
fi

~/scripts/mukesh-sync-system-config.sh

#chsh -s `which zsh`
sudo usermod --shell /bin/zsh $USER

git clone --depth 1 https://github.com/wbthomason/packer.nvim \
	~/.local/share/nvim/site/pack/packer/start/packer.nvim

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

echo "Install tmux plugin using <Ctrl+b I>"
