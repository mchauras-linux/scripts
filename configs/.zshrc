# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$PATH:$HOME/scripts:/$HOME/mukesh_tools/:$HOME/qemu/build:/home/linuxbrew/.linuxbrew/bin
export PATH=$PATH:$HOME/scripts/scheduler:$HOME/scripts/perf:$HOME/scripts/mm:$HOME/scripts/agenda:$HOME/scripts/linux-build:$HOME/scripts/system:$HOME/scripts/qemu:$HOME/scripts/misc-scripts:$HOME/scripts/git:$HOME/scripts/fs:$HOME/scripts/emacs:$HOME/scripts/bpf-scripts

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="robbyrussell"
#ZSH_THEME=random
#ZSH_THEME=agnoster
#ZSH_THEME=avit
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git
	pylint 
	vscode 
	copybuffer 
	colored-man-pages 
	colorize 
	command-not-found 
	dirhistory 
	zsh-syntax-highlighting 
	zsh-autosuggestions
	#zsh-autocomplete
	fzf
	fzf-tab
	sudo
	web-search
	copyfile
	history
	jsontools
	)
# fzf environment variables
export FZF_BASE=/home/mukesh/.fzf
export FZF_PREVIEW_ADVANCED=true
export FZF_DEFAULT_OPTS='-m --height 60% --layout=reverse --border'
#export FZF_PREVIEW_WINDOW=''

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.zsh_func ] && source ~/.zsh_func
[ -f ~/.zsh_aliases ] && source ~/.zsh_aliases
[ -f ~/.zshenv ] && source ~/.zshenv
[ -f ~/.zsh_system ] && source ~/.zsh_system

# User Defined
if ((  $+commands[emacsclient]  ))
then
	export CSCOPE_EDITOR=/usr/bin/emacsclient
	export EDITOR='emacsclient'
elif (( $+commands[nvim] ))
then
	export CSCOPE_EDITOR=/usr/bin/nvim
	export EDITOR='nvim'
else
	export CSCOPE_EDITOR=/usr/bin/vim
	export EDITOR='vim'
fi
export LC_ALL=en_IN.UTF-8
export LANG=en_IN.UTF-8
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=100000000
export SAVEHIST=100000000

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Created by `userpath` on 2024-01-04 18:46:51
export PATH="$PATH:/home/mchauras/.local/bin"
