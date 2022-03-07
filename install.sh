#!/bin/sh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || exit

__dirname=$(cd "$(dirname "$0")" || exit 1; pwd)
cd "$__dirname" || exit 1

sudo apt install build-essential gcc cmake
./update.sh

cd - || exit
