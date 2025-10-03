# From https://github.com/consolemaverick/zsh2000/blob/574cbee55ba02bdb2a6200f93ae144a64ea6fa6f/zsh2000.zsh-theme
CURRENT_BG='NONE'
SEGMENT_SEPARATOR_RIGHT='\ue0b2'
SEGMENT_SEPARATOR_LEFT='\ue0b0'
prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != "$CURRENT_BG" ]]; then
    echo -n " %{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR_LEFT%{$fg%} "
  else
    echo -n "%{$bg%}%{$fg%}"
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && echo -n "$3"
}

prompt_segment_right() {
	local bg fg
	[[ -n $1 ]] && bg="%K{$1}" || bg="%k"
	[[ -n $2 ]] && fg="%F{$2}" || fg="%f"
	echo -n "%K{$CURRENT_BG}%F{$1}$SEGMENT_SEPARATOR_RIGHT%{$bg%}%{$fg%} "
	CURRENT_BG=$1
	[[ -n $3 ]] && echo -n "$3"
}

prompt_end() {
	if [[ $CURRENT_BG != 'NONE' ]] &&[[ $CURRENT_BG != 'default' ]] && [[ -n $CURRENT_BG ]]; then
		echo -n " %{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR_LEFT"
	else
		echo -n "%{%k%}"
	fi
	echo -n "%{%f%}"
	CURRENT_BG=''
}

prompt_segment_set_start_status() {
	CURRENT_BG='NONE'
}
prompt_segment_start() {
	prompt_segment_set_start_status
	prompt_segment "$1" "$2" "$3"
}





# from https://github.com/Tesohh/omzbigpath/blob/master/bigpath.zsh-theme
# but in associative array variable
__znm_colors=( )
typeset -gA __znm_colors
if [[ $TERM = *256color* || $TERM = *rxvt* ]]; then
    __znm_colors[turquoise]="%F{81}"
    __znm_colors[red]="%F{196}"
    __znm_colors[orange]="%F{166}"
    __znm_colors[purple]="%F{135}"
    __znm_colors[hotpink]="%F{161}"
    __znm_colors[limegreen]="%F{118}"
    __znm_colors[gray]="%F{8}"
else
    # shellcheck disable=SC1087
    __znm_colors[turquoise]="$fg[cyan]"
    # shellcheck disable=SC1087
    __znm_colors[orange]="$fg[yellow]"
    # shellcheck disable=SC1087
    __znm_colors[purple]="$fg[magenta]"
    # shellcheck disable=SC1087
    __znm_colors[hotpink]="$fg[red]"
    # shellcheck disable=SC1087
    __znm_colors[limegreen]="$fg[green]"
fi



source "$HOME/.znm-conf.zsh/utils.zsh"
# From https://github.com/spaceship-prompt/spaceship-prompt/blob/b92b7d2ecb8ded6b1a0ff72617f0106bbe8dcc69/sections/node.zsh
__node_version() {
	setopt extendedglob

	# Show NODE status only for JS-specific folders
	# [[ -f package.json || -d node_modules || -n *.js(#qN^/) ]] || return
	[[ -f package.json || -d node_modules ]] || return

	local node_version

	if __znm_cmd_exists fnm; then
		node_version=$(fnm current 2>/dev/null)
		[[ $node_version == "system" || $node_version == "node" ]] && return
	elif __znm_cmd_exists nvm; then
		node_version=$(nvm current 2>/dev/null)
		[[ $node_version == "system" || $node_version == "node" ]] && return
	elif __znm_cmd_exists nodenv; then
		node_version=$(nodenv version-name)
		[[ $node_version == "system" || $node_version == "node" ]] && return
	elif __znm_cmd_exists node; then
		node_version=$(node -v 2>/dev/null)
	else
		return
	fi

	local default_version=''
	if __znm_cmd_exists apt-show-versions; then
	default_version=$(apt-show-versions nodejs | cut -d' ' -f2 | cut -d'-' -f1)
	fi

	node_version=${node_version/v/}
	if [[ $node_version != "$default_version" ]]; then
		prompt_segment green white "⬢ ${node_version}"
	fi
}

__node_packages() {
	[[ -f package.json || -d node_modules ]] || return

    local packageList
    # shellcheck disable=SC2207
	packageList=($(jq -r '.dependencies + .devDependencies // [] |keys|unique|.[]' package.json))

	for packageName in "${packageList[@]}"
	do
		if [[ "$packageName" == 'gulp' ]]; then prompt_segment red white "🥤"; fi
		if [[ "$packageName" == 'webpack' ]]; then prompt_segment 39 white "⬢"; fi
	done
}

# From https://github.com/spaceship-prompt/spaceship-prompt/blob/b92b7d2ecb8ded6b1a0ff72617f0106bbe8dcc69/sections/php.zsh
__php_version() {
	setopt extendedglob

	# Show only if php files or composer.json exist in current directory
	# [[ -n *.php(#qN^/) || -f composer.json ]] || return
	[[ -f composer.json ]] || return

	__znm_cmd_exists php || return

	local php_version
	php_version=$(php -v 2>&1 | \grep --color=never -oe "^PHP\s*[0-9.]\+" | awk '{print $2}')
	local default_version=''
	if __znm_cmd_exists apt-show-versions; then
		default_version=$(apt-show-versions php | cut -d' ' -f2 | cut -d'-' -f1)
	fi

	php_version=${php_version/v/}
	if [[ $php_version != "$default_version" ]]; then
		prompt_segment 20 white "🐘 ${php_version}"
	fi
}

__docker_version() {
	[[ -f 'Dockerfile' || -f 'docker-compose.yml' ]] || return

	prompt_segment 33 white "🐳"
}

__terraform_prompt() {
	__znm_cmd_exists terraform || return
	[[ -d '.terraform' ]] || return

	terraform_workspace="$(command terraform workspace show 2>/dev/null)"

	color="magenta"
	if [[ $(echo "$terraform_workspace" | tr '[:upper:]' '[:lower:]') == "prod" ]]; then
		color="red"
	fi
	prompt_segment "$color" white "🏗️  ${terraform_workspace}"
}



ZNM_GIT_SHOW_STATUS='1'
# from https://github.com/Ottootto2010/funkyberlin-zsh-theme/blob/c93f59bab345b8a62dcee90592439912ebf4563f/funkyberlin.zsh-theme#L22
__git_status() {
	local STATUS=""

#	local ZSH_THEME_GIT_PROMPT_STAGED="%{$FG[green]%}●"
#	local ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$FG[red]%}●"
#	local ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[red]%}●"
#
#	# check status of files
#	local INDEX
#	INDEX=$(command git status --porcelain 2> /dev/null)
#	if [[ -n "$INDEX" ]]; then
#		if $(echo "$_INDEX" | command grep -q '^[AMRD]. '); then
#			STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_STAGED"
#		fi
#		if $(echo "$_INDEX" | command grep -q '^.[MTD] '); then
#			STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNSTAGED"
#		fi
#		if $(echo "$_INDEX" | command grep -q -E '^\?\? '); then
#			STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNTRACKED"
#		fi
#		if $(echo "$_INDEX" | command grep -q '^UU '); then
#			STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNMERGED"
#		fi
#	fi

	local ZSH_THEME_GIT_PROMPT_AHEAD="%{${__znm_colors[orange]}%}⇡"
	local ZSH_THEME_GIT_PROMPT_BEHIND="%{${__znm_colors[limegreen]}%}⇣"
	local ZSH_THEME_GIT_PROMPT_DIVERGED="%{${__znm_colors[red]}%}⇕"

	# check status of local repository
	INDEX=$(command git status --porcelain -b 2> /dev/null)
	if $(echo "$INDEX" | command grep -q '^## .*ahead'); then
		STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_AHEAD"
	fi
	if $(echo "$INDEX" | command grep -q '^## .*behind'); then
		STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_BEHIND"
	fi
	if $(echo "$INDEX" | command grep -q '^## .*diverged'); then
		STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_DIVERGED"
	fi

	echo -n "$STATUS"
}
__git_prompt() {
	local ref=''
	local branch=''
	ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
	ref=$(command git rev-parse --short HEAD 2> /dev/null)
	if [[ $ref != '' ]]; then
		branch="${ref#refs/heads/}"
	fi

	local result=""
	if [[ -n "$branch" ]]; then
		result="$branch"

		if [[ -n "$ZNM_GIT_SHOW_STATUS" ]]; then
			local _status
			_status=$(__git_status)
			if [[ -n "${_status}" ]]; then
				result="$result $_status"
			fi
		fi

		prompt_segment 6 white "  $result"
	fi
}



# From (and modified) https://github.com/caiogondim/bullet-train.zsh/blob/d60f62c34b3d9253292eb8be81fb46fa65d8f048/bullet-train.zsh-theme#L387
function __znm_display_time {
	local T=$1
	local MS=$((1000*(T%1)))
	T=$(printf '%d' "$T")
	local D=$((T/60/60/24))
	local H=$((T/60/60%24))
	local M=$((T/60%60))
	local S=$((T%60))
	[[ $D -gt 0 ]] && printf '%dd' $D
	[[ $H -gt 0 ]] && printf '%dh' $H
	[[ $M -gt 0 ]] && printf '%dm' $M
	[[ $S -gt 0 ]] && printf '%ds' $S
	[[ $MS -gt 0 ]] && printf '%dms' $MS
}

function __znm_background_tasks() {
	local backgroundJobs
	backgroundJobs=$(jobs -l | wc -l)
	if [[ $backgroundJobs -gt 0 ]]; then
		echo " %F{magenta}${backgroundJobs}⚙"
	fi
}

__zatsunenomokou_preexec() {
	__zsh_znm_preexec_start_time=${EPOCHREALTIME}
	__znm_elapse=''
}

__znm_elapse=''
__zatsunenomokou_precmd() {
	__znm_elapse=''
	if [ -n "${__zsh_znm_preexec_start_time}" ]; then
		local end=${EPOCHREALTIME}
		local duration=$((end - __zsh_znm_preexec_start_time))
		# shellcheck disable=SC2072
		if [[ $duration -gt 0.5 ]]; then
 			# Only show if duration > 500ms
			__znm_elapse=" %F{cyan}$(__znm_display_time $duration)⚡ %{$reset_color%}"
		fi
		unset __zsh_znm_preexec_start_time
	fi
}
autoload -U add-zsh-hook
add-zsh-hook precmd __zatsunenomokou_precmd
add-zsh-hook preexec __zatsunenomokou_preexec



__zatsunenomokou_buildPrompt() {
	echo -n "\n"
	prompt_segment default cyan "%n@%m "
	prompt_segment default white "%~ "

	prompt_segment_set_start_status
	__git_prompt
	__php_version
	__docker_version
	__node_version
	__node_packages
	__terraform_prompt
	prompt_end

	printf "\n"
	prompt_segment_start cyan default "%T"

	local NCOLOR;
	if [ $UID -eq 0 ]; then NCOLOR="red"; else NCOLOR="cyan"; fi
	prompt_segment default "$NCOLOR" "%(!.#.»)"
	prompt_end
}
# shellcheck disable=SC2016
# shellcheck disable=SC2034
PROMPT='%{%f%b%k%}$(__zatsunenomokou_buildPrompt) '
# shellcheck disable=SC2016
# shellcheck disable=SC2034
RPS1='%(?..%{$fg[red]%}%?↵%{$reset_color%})${__znm_elapse}$(__znm_background_tasks)'
