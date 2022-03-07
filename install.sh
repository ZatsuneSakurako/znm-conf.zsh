#!/bin/sh

if [ ! -e ~/.oh-my-zsh ]; then
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || exit
fi

if [ -z ${which cmake} ]; then
  echo 'Installing libs'
  sudo apt install build-essential gcc cmake
fi

if [ -e ~/.zshrc ]; then
  if [ -e ~/.zshrc.bak ]; then echo '.zshrc.bak already exist' && exit 1; fi
  mv ~/.zshrc ~/.zshrc.bak
fi

if [ -e ~/znm-conf.zsh ]; then
  git clone "git@gitlab.com:ZatsuneNoMokou/znm-conf.zsh.git" ~/.znm-conf.zsh
fi

./update.sh
