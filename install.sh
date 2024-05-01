#!/bin/sh

if __znm_cmd_exists apk; then
	if ! __znm_cmd_exists pip3; then
		sudo apk add python3 py3-pip py3-setuptools python3-dev musl-dev linux-headers
	fi
fi

if [ -z "$(which git)" ] || [ -z "$(which zsh)" ]; then
	echo 'Installing libs'
	if __znm_cmd_exists apt; then
		sudo apt install git zsh curl wget fonts-powerline
	elif __znm_cmd_exists apk; then
		sudo apk install git zsh curl wget

		git clone --depth 1 https://github.com/powerline/fonts pl-fonts \
		&& (cd pl-fonts || exit 1) \
		&& ./install.sh \
		&& (cd - || exit 1)

		mkdir -p "$HOME/.config/fontconfig/conf.d/" && \
		curl -L "https://github.com/powerline/powerline/blob/develop/font/10-powerline-symbols.conf" -o ~/.config/fontconfig/conf.d/10-powerline-symbols.conf
	else
		echo "Unknown package manager !"
	fi
fi

if [ -z "$(which thefuck)" ]; then
	echo 'Installing libs'
	if __znm_cmd_exists apt; then
		sudo apt install thefuck
	elif __znm_cmd_exists apk; then
		pip3 install thefuck
	else
		echo "Unknown package manager !"
	fi
fi

if [ ! -e ~/.oh-my-zsh ]; then
	sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || exit
fi

if [ -z "$(which cmake)" ]; then
	echo 'Installing libs'

	if __znm_cmd_exists apt; then
		sudo apt install build-essential gcc cmake
	elif __znm_cmd_exists apk; then
		sudo apk add alpine-sdk gcc
	else
		echo "Unknown package manager !"
	fi
fi

if [ -e ~/.zshrc ]; then
	if [ -e ~/.zshrc.bak ]; then echo '.zshrc.bak already exist' && exit 1; fi
	mv ~/.zshrc ~/.zshrc.bak
fi

touch ~/.znm-conf_check
~/.znm-conf.zsh/update.sh
