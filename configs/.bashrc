# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# User specific environment
PATH="$HOME/.local/bin:$HOME/bin:$PATH"
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
alias gits="git status"
if command -v nvim -v &> /dev/null
then
	echo "NVIM Found"
	alias vim="nvim"
	alias vi="nvim"
	CSCOPE_EDITOR=nvim
	EDITOR=nvim
else
	export CSCOPE_EDITOR=/usr/bin/vim
	export EDITOR='vim'
fi


# Use custom bash prompt (will execute .bash_prompt script)
if [ -f ~/.bash_prompt ]; then
  . ~/.bash_prompt
fi

export PATH=$PATH:$HOME/scripts/:/$HOME/mukesh_tools/:$HOME/qemu/build:/home/linuxbrew/.linuxbrew/bin


. "$HOME/.cargo/env"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
