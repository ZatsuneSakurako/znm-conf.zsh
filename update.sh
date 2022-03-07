#!/bin/sh
__dirname=$(cd "$(dirname "$0")" || exit 1; pwd)
cd "$__dirname" || exit 1

mkdir -p ~/bin
curl -L git.io/antigen > ~/bin/antigen.zsh

if [ ! -e ~/.bash_aliases ]; then
  touch ~/.gitignore
  git config --global core.excludesFile ~/.gitignore
fi

if [ ! -e ~/.bash_aliases ]; then touch ~/.bash_aliases;fi

git pull
ln -sf "${__dirname}/zatsunenomokou_custom_theme.zsh-theme" ~/.oh-my-zsh/custom/themes/zatsunenomokou_custom_theme.zsh-theme
ln -s "${__dirname}/zshrc" ~/.zshrc

cd - || exit
