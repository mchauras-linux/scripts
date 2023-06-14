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
if ! command -v nvim -v &> /dev/null
then
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

PATH=$PATH:/home/$USER/scripts/:/home/$USER/mukesh_tools/:/home/$USER/qemu/build


. "$HOME/.cargo/env"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
