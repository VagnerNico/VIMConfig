#!/bin/bash
if ! command -v vim &> /dev/null
then
    echo "<vim> could not be found, please install it and try again."
    exit
fi

if ! command -v nvim &> /dev/null
then
    echo "<nvim> could not be found, please install it and try again."
    exit
fi

if ! command -v lvim &> /dev/null
then
    echo "<lvim> could not be found, please install it and try again."
    exit
fi

if ! command -v npm &> /dev/null
then
    echo "<npm> could not be found, please install it because it's required for some vim plugins."
    exit
fi

# vim-plug installation for vim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Copying the vim and nvim configs
cp vim/.vimrc $HOME
mkdir -p $HOME/.config/nvim
cp -r nvim/* $HOME/.config/nvim
cp lvim/config.lua $HOME/.config/lvim/config.lua

# Installing config plugins
vim -c "PlugInstall" -c q! -c q!
nvim -c "PackerInstall" -c q! -c q!

if [[ $OSTYPE == 'darwin'* ]]; then
    nvim $HOME/.config/.vimrc -c "/set termguicolors" -c .d -c .d -c wq
fi
