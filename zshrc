function () {
	function file_days_old {
		if [ -f "$1" ]; then
			echo $((($(date +%s) - $(date +%s -r "$1")) / 86400))
			return 0
		fi
		echo "-1"
		return -1
	}

	local old=$(file_days_old "$HOME/.znm-conf_check")
	if [[ $old > 1 ]] || [[ $old == -1 ]]; then
		date -u -Ins > ~/.znm-conf_check

		cd ~/.znm-conf.zsh
		git pull --quiet
		cd -

		~/.znm-conf.zsh/update.sh
	fi
	unset old;
}



# If you come from bash you might have to change your $PATH.
export PATH=$PATH:./node_modules/.bin

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="zatsunenomokou_custom_theme"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
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
HIST_STAMPS="mm/dd/yyyy"





# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
#plugins=(
#	git
#	zsh-completions
#)

#autoload -U compinit && compinit


znm () {
	local __dirname=$(cd "$(dirname "$0")" || exit 1; pwd);

	local firstArg=$1
	local args=()
	for i ($*) {
		args+=("\"${i//\"//\\\"}\"")
	}
	shift args

	echo $(zsh -c "\"$HOME/.znm-conf.zsh/bin/$1\" ${args[@]}");
}
# From https://stackoverflow.com/questions/17767208/writing-a-zsh-autocomplete-function
# See https://zsh.sourceforge.io/Doc/Release/Completion-Using-compctl.html
_znm_autocompl() {
	cd $HOME/.znm-conf.zsh/bin/
	reply=("${(@f)$(ls -D .)}")
	local _void=$(cd -)
}
compctl -K _znm_autocompl znm


source $ZSH/oh-my-zsh.sh
source ~/bin/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

local antigenPlugins=(
	# Bundles from the default repo (robbyrussell's oh-my-zsh).
	'git'

	'pip'
	'zsh-users/zsh-completions'
	'zsh-users/zsh-autosuggestions'
	'command-not-found'
	'docker'
	'docker-compose'
	'pm2'
	'dotenv'
	'ubuntu'
	'gulp'
	'node'
	'yarn'
	'wp-cli'
	
	# tmux-mem-cpu-load
	'thewtex/tmux-mem-cpu-load'

	# Syntax highlighting bundle.
	'zsh-users/zsh-syntax-highlighting'
)
for x in $antigenPlugins; do antigen bundle $x; done

if [ -f ~/.zshrc.local ]; then . ~/.zshrc.local; fi

if [ -d "$HOME/.nvm" ]; then
	export NVM_DIR="$HOME/.nvm"
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
	[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

	# place this after nvm initialization!
	autoload -U add-zsh-hook
	load-nvmrc() {
		local node_version="$(nvm version)"
		local nvmrc_path="$(nvm_find_nvmrc)"

		if [ -n "$nvmrc_path" ]; then
			local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

			if [ "$nvmrc_node_version" = "N/A" ]; then
				nvm install
			elif [ "$nvmrc_node_version" != "$node_version" ]; then
				nvm use
			fi
		elif [ "$node_version" != "$(nvm version default)" ]; then
			echo "Reverting to nvm default version"
			nvm use default
		fi
	}
	add-zsh-hook chpwd load-nvmrc
	load-nvmrc
fi

if [ -d "$HOME/.bun" ]; then
	source "$HOME/.bun/_bun"
	
	# bun
	export BUN_INSTALL="$HOME/.bun"
	export PATH="$BUN_INSTALL/bin:$PATH"
fi

antigen apply

if [ ! -z "$(which thefuck)" ]; then
	eval $(thefuck --alias)
fi

if [ -f ~/.bash_aliases ]; then . ~/.bash_aliases; fi





# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
export EDITOR='nano'
export VISUAL=$EDITOR

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias lla='ll -A'
alias ll='l -l'
alias la='l -A'
alias l='ls --group-directories-first -hCF'

