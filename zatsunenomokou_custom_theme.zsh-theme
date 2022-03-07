if [ $UID -eq 0 ]; then NCOLOR="red"; else NCOLOR="cyan"; fi
local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"



ZSH_SHOW_GIT_DIRTY=0;

git_branch_info() {
	(( $+commands[git] )) || return
	if [[ "$(git config --get oh-my-zsh.hide-status 2>/dev/null)" = 1 ]]; then
		return
	fi

	if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
		local repo_branch_name dirty

		repo_branch_name=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)



		if [[ $ZSH_SHOW_GIT_DIRTY -ne 0 ]]; then
			# dirty=$(parse_git_dirty)
			dirty=$(git status --porcelain --untracked-files=no --ignore-submodules=dirty 2>/dev/null | tail -n1)

			if [[ -n $dirty ]]; then
				dirty="${ZSH_THEME_GIT_PROMPT_DIRTY}"
			else
				dirty="${ZSH_THEME_GIT_PROMPT_CLEAN}"
			fi
		fi


		
		echo -n "${ZSH_THEME_GIT_PROMPT_PREFIX}${repo_branch_name}${dirty}${ZSH_THEME_GIT_PROMPT_SUFFIX}"
	fi
}

PROMPT='%{$fg[$NCOLOR]%}%n%{$fg[cyan]%}@%m%{$reset_color%} %~ \
$(git_branch_info)%{$reset_color%}\
%{$fg[red]%}%(!.#.»)%{$reset_color%} '

PROMPT2='%{$fg[red]%}\ %{$reset_color%}'

RPS1='${return_code}'



ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[yellow]%}*"