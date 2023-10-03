#! /bin/bash

CONFIG=~/scripts/configs
CONFIG_NEOVIM=~/.config/nvim
BRANCH="$(hostname)-$(date "+%Y-%m-%d-%H-%M-%S")"
if [ -f ~/.mukesh_configured ] 
then
	cd ~/scripts
	git pull
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

	if [[ $(git status --porcelain) ]]; then
		git checkout -b $BRANCH

		git add \
			configs/.vimrc \
			configs/.bashrc \
			configs/.bash_prompt \
			configs/.bash_profile \
			configs/.zshrc \
			configs/.zsh_func \
			configs/.p10k.zsh \
			configs/.tmux.conf \
			configs/nvim \
			configs/.zsh_aliases

		git add mukesh-*
		git add docs

		git status

		git commit -m "Updated at $(date "+%Y-%m-%d %H:%M:%S")"
		echo -e "\n\nPushing All configs to scripts repo\n\n"
		git push --set-upstream origin $BRANCH
	fi
	git checkout master
else
	read -p "Do you want this user to be configured as mukesh_configured? [N/y]" yn
	case $yn in
		[yY] )
			touch ~/.mukesh_configured;;
		* ) echo Skipping Configuration;;
	esac

fi

cd
