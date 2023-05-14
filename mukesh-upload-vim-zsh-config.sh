#! /bin/bash

CONFIG=~/scripts/configs
CONFIG_NEOVIM=~/.config/nvim

cp ~/.vimrc $CONFIG 
cp ~/.bashrc $CONFIG 
cp ~/.bash_prompt $CONFIG 
cp ~/.bash_profile $CONFIG 
cp ~/.zshrc $CONFIG 
cp ~/.zsh_func $CONFIG
cp ~/.zsh_aliases $CONFIG
cp ~/.p10k.zsh $CONFIG
cp ~/.tmux.conf $CONFIG 
cp -rf $CONFIG_NEOVIM $CONFIG


cd ~/scripts

if [ -f ~/.zshrc ] 
then
	git add 		\
	configs/.vimrc 		\
	configs/.bashrc 	\
	configs/.bash_prompt 	\
	configs/.bash_profile 	\
	configs/.zshrc 		\
	configs/.zsh_func 	\
	configs/.p10k.zsh 	\
	configs/.tmux.conf 	\
	configs/nvim	 	\
	configs/.zsh_aliases
        
        git status

	git commit -m "Updated vim and zsh config"
	echo -e "\n\nPushing All configs to scripts repo\n\n"
	git push
fi
