#!/usr/bin/env bash

set -euo pipefail

BACKUP_DIR="${BACKUP_DIR:-$HOME/dotfiles_backupi_$(date +%s%N)}"
CONFIG_DIR=$HOME/.config
CONFIG_DOT_DIR=$HOME/dotfiles/config
DOT_DIR=$HOME/dotfiles
FONTS_DIR=$HOME/dotfiles/fonts

execute_extra=0
while getopts "e" opt; do
  case ${opt} in
    e) 
       execute_extra=1
       ;;
    \?)
       echo "Invalid option: -$OPTARG" 1>&2
       exit 1
       ;;
  esac
done

_exit_if_exists(){
	local src=$1
	if [ -d "$src" ]; then
		echo "Dierectory $src exists."
		return 1
	fi
}

_exit_if_not_exists(){
	local src=$1
	if [ ! -d "$src" ]; then
		echo "Directory $src does not exist"
		return 1
	fi
}

_mkdir() {
	local src=$1
	_exit_if_exists $src

	mkdir -p $src
	echo "Directory $src created"
}

_link(){
	local src=$1
	local dst=$2

	_exit_if_not_exists $src

	ln -s -f $src $dst
	echo "Symbolic link $src -> $dst created"
}

create_backup(){
	local src=$CONFIG_DIR
	local dst=$BACKUP_DIR

	_exit_if_exists $dst

	_mkdir $dst
	cp -R $src $dst
	echo "Backup complete $src -> $dst"
	rm -fr $src
}

restore_backup(){
	local src=$BACKUP_DIR
	local dst=$CONFIG_DIR

	rm -fr $dst
	cp -R $src $dst
	echo "Backup restore complete $src -> $dst"
}

config_link() {
	local src=$CONFIG_DOT_DIR
	local dst=$CONFIG_DIR

    rm -fr $CONFIG_DIR

	_link $src $dst
    i3 reload
}

pacman_install() {
	sudo pacman -Syy --noconfirm
	sudo pacman -S bat fzf unzip fd ripgrep zsh alacritty neovim tmux font-manager gnome-themes-extra pcmanfm --noconfirm
}

nvm_node(){
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
    source $HOME/.bashrc
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    nvm install node --lts
}

shell_config(){
    sudo chsh -s $(which zsh) $(whoami)
    echo $'EDITOR=nvim\nTERMINAL=alacritty' | sudo tee -a /etc/environment
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    ln -s -f $DOT_DIR/zshrc $HOME/.zshrc
}

oh_my_tmux(){
    pushd $HOME
    git clone https://github.com/gpakosz/.tmux.git
    ln -s -f .tmux/.tmux.conf
    cp .tmux/.tmux.conf.local .
    popd
}

yay_install(){
    pushd $HOME
    sudo pacman -S --needed base-devel
    git clone https://aur.archlinux.org/yay.git
    pushd yay
    makepkg -si --noconfirm
    popd
    rm -fr yay
    popd
    # Color
    sudo sed -i 's/^#Color/Color/' /etc/pacman.conf
}

packer(){
    _mkdir $CONFIG_DIR/nvim/lua/dcorral
    cp $CONFIG_DOT_DIR/nvim/lua/dcorral/packer.lua $CONFIG_DIR/nvim/lua/dcorral/packer.lua

    git clone --depth 1 https://github.com/wbthomason/packer.nvim\
        ~/.local/share/nvim/site/pack/packer/start/packer.nvim

    nvim --headless -c "source $CONFIG_DIR/nvim/lua/dcorral/packer.lua" -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
    nvim --headless -c "source $CONFIG_DIR/nvim/lua/dcorral/packer.lua" -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
}

fonts(){
    font-manager -i $FONTS_DIR/*
    i3 reload
}

p10k(){
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    ln -s -f $DOT_DIR/p10k.zsh $HOME/.p10k.zsh
}

extra_packages(){
    yay -S microsoft-edge-stable-bin ledger-live-bin --noconfirm
    sudo pacman -S telegram-desktop bitwarden --noconfirm
}

keyboardmap(){
    ln -s -f $DOT_DIR/xinitrc $HOME/.xinitrc
    ln -s -f $DOT_DIR/Xkeymap $HOME/.Xkeymap
}

gtk2(){
    ln -s -f $DOT_DIR/gtkrc-2.0 $HOME/.gtkrc-2.0
}

i3lock(){
    sudo ln -s -f $DOT_DIR/i3lock.service /etc/systemd/system/i3lock.service
    sudo systemctl enable i3lock.service
}

main(){
	create_backup
	pacman_install
    nvm_node
    packer
	config_link
    fonts
	shell_config
    oh_my_tmux
    p10k
    yay_install
    if [[ $execute_extra -eq 1 ]]; then
        extra_packages
    fi
    keyboardmap
    gtk2
    i3lock
}

main


