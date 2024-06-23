#! /bin/bash

CONFIG=~/scripts/configs
CONFIG_NEOVIM=~/.config/nvim

cd $CONFIG
git pull

cp $CONFIG/.vimrc ~/
cp $CONFIG/.bashrc ~/
cp $CONFIG/.bash_prompt ~/
cp $CONFIG/.bash_profile ~/
cp $CONFIG/.zshrc ~/
cp $CONFIG/.zsh_aliases ~/
cp $CONFIG/.zsh_func ~/
cp $CONFIG/.p10k.zsh ~/
cp $CONFIG/.tmux.conf ~/
cp $CONFIG/.spacemacs ~/
cp $CONFIG/.gdbinit ~/
cp -rf $CONFIG/nvim ~/.config

git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d

if [ ! -d ~/.oh-my-zsh ]; then

	# Clone all plugins and themes for zsh
	git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh

	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
		${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

	git clone https://github.com/Aloxaf/fzf-tab \
		${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab

	git clone https://github.com/marlonrichert/zsh-autocomplete.git \
		${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autocomplete

	git clone https://github.com/zsh-users/zsh-autosuggestions \
		${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
		${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

fi

case "$-" in
*i*)
	interactive=1
	sudo cp -rf $CONFIG/fonts/* /usr/share/fonts
	;;
*)
	not_interactive=1
	;;
esac
