if [ $UID -eq 0 ]; then NCOLOR="red"; else NCOLOR="cyan"; fi
local return_code="%(?..%{$fg[red]%}%?↵%{$reset_color%})"



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
    __znm_colors[turquoise]="$fg[cyan]"
    __znm_colors[orange]="$fg[yellow]"
    __znm_colors[purple]="$fg[magenta]"
    __znm_colors[hotpink]="$fg[red]"
    __znm_colors[limegreen]="$fg[green]"
fi



source "$HOME/.znm-conf.zsh/utils.zsh"
# From https://github.com/spaceship-prompt/spaceship-prompt/blob/b92b7d2ecb8ded6b1a0ff72617f0106bbe8dcc69/sections/node.zsh
__node_version() {
	setopt extendedglob
	local NODE_SYMBOL="⬢ "

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
	if [[ $node_version != $default_version ]]; then
		echo -n "%{%B%F{"green"}%}⬢ ${node_version}%{%b%f%}"
	fi
}



ZNM_GIT_SHOW_STATUS=''
# from https://github.com/Ottootto2010/funkyberlin-zsh-theme/blob/c93f59bab345b8a62dcee90592439912ebf4563f/funkyberlin.zsh-theme#L22
__git_status() {
	local ZSH_THEME_GIT_PROMPT_CLEAN="%{$FG[154]%}✓%{$reset_color%}"
	local ZSH_THEME_GIT_PROMPT_AHEAD="%{$FG[154]%}▴%{$reset_color%}"
	local ZSH_THEME_GIT_PROMPT_BEHIND="%{$FG[196]%}▾%{$reset_color%}"
	local ZSH_THEME_GIT_PROMPT_STAGED="%{$FG[154]%}●%{$reset_color%}"
	local ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$FG[202]%}●%{$reset_color%}"
	local ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[red]%}●%{$reset_color%}"
	local STATUS=""

	# check status of files
	local INDEX=$(command git status --porcelain 2> /dev/null)
	if [[ -n "$INDEX" ]]; then
		if $(echo "$_INDEX" | command grep -q '^[AMRD]. '); then
			STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_STAGED"
		fi
		if $(echo "$_INDEX" | command grep -q '^.[MTD] '); then
			STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNSTAGED"
		fi
		if $(echo "$_INDEX" | command grep -q -E '^\?\? '); then
			STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNTRACKED"
		fi
		if $(echo "$_INDEX" | command grep -q '^UU '); then
			STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNMERGED"
		fi
		else
			STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_CLEAN"
	fi

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

	if $(command git rev-parse --verify refs/stash &> /dev/null); then
		STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_STASHED"
	fi

	echo $STATUS
}
__git_prompt() {
	local ZSH_THEME_GIT_PROMPT_PREFIX=" [git%{$reset_color%}%{$FG[176]%} "
	local ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}]"

	local ref=''
	local branch=''
	ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
	ref=$(command git rev-parse --short HEAD 2> /dev/null)
	if [[ $ref != '' ]]; then
		branch="${ref#refs/heads/}"
	fi

	local result=""
	if [[ -n "$branch" ]]; then
		result="$ZSH_THEME_GIT_PROMPT_PREFIX$branch"

		if [[ -n "$ZNM_GIT_SHOW_STATUS" ]]; then
			local _status=$(__git_status)
			if [[ "${_status}x" != "x" ]]; then
				result="$result $_status"
			fi
		fi

		result="$result$ZSH_THEME_GIT_PROMPT_SUFFIX"
	fi
	echo $result
}



# From (and modified) https://github.com/caiogondim/bullet-train.zsh/blob/d60f62c34b3d9253292eb8be81fb46fa65d8f048/bullet-train.zsh-theme#L387
function __znm_display_time {
	local T=$1
	local MS=$((1000*(T%1)))
	T=$(printf '%d' $T)
	local D=$((T/60/60/24))
	local H=$((T/60/60%24))
	local M=$((T/60%60))
	local S=$((T%60))
	[[ $D > 0 ]] && printf '%dd' $D
	[[ $H > 0 ]] && printf '%dh' $H
	[[ $M > 0 ]] && printf '%dm' $M
	[[ $S > 0 ]] && printf '%ds' $S
	[[ $MS > 0 ]] && printf '%dms' $MS
}

function __znm_background_tasks() {
	local backgroundJobs=$(jobs -l | wc -l)
	if [[ $backgroundJobs -gt 0 ]]; then
		echo " %{$__znm_colors[purple]%}${backgroundJobs}⚙"
	fi
}

__zatsunenomokou_preexec() {
	__zsh_znm_preexec_start_time=${EPOCHREALTIME}
	__znm_elapse=''
}

__znm_elapse=''
__zatsunenomokou_precmd() {
	znm_elapse=''
	if [ -n "${__zsh_znm_preexec_start_time}" ]; then
		local end=${EPOCHREALTIME}
		local duration=$((end - __zsh_znm_preexec_start_time))
		if [[ $duration -gt 0.5 ]]; then
 			# Only show if duration > 500ms
			__znm_elapse=" %F{cyan}$(__znm_display_time $duration)⚡ %{$reset_color%}"
		fi
		unset __zsh_znm_preexec_start_time
	fi

	print
	local username="%{$fg[$NCOLOR]%}%n%{$fg[cyan]%}@%m%{$reset_color%}"
	print -P "${username} %~$(__git_prompt) $(__php_version) $(__node_version)"
}
autoload -U add-zsh-hook
add-zsh-hook precmd __zatsunenomokou_precmd
add-zsh-hook preexec __zatsunenomokou_preexec



PROMPT='%D{%T} %{$fg[red]%}%(!.#.»)%{$reset_color%} '
RPS1='${return_code}${__znm_elapse}$(__znm_background_tasks)'
