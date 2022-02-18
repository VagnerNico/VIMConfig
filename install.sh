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

if ! command -v npm &> /dev/null
then
    echo "<npm> could not be found, please install it because it's required for some vim plugins."
    exit
fi

# vim-plug installation for vim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# vim-plug installation for nvim
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# Copying the vim and nvim configs
cp vim/.vimrc $HOME
mkdir -p $HOME/.config/nvim
cp nvim/* $HOME/.config/nvim

# Installing config plugins
vim -c "PlugInstall" -c q! -c q!
nvim -c "PlugInstall" -c q! -c q!

if [[ $OSTYPE == 'darwin'* ]]; then
    nvim $HOME/.config/.vimrc -c "/set termguicolors" -c .d -c .d -c wq
    nvim $HOME/.config/nvim/init.vim -c "/set termguicolors" -c .d -c .d -c wq
fi
