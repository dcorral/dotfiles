#!/usr/bin/env bash

set -euo pipefail

BACKUP_DIR="${BACKUP_DIR:-$HOME/dotfiles_backupi_$(date +%s%N)}"
CONFIG_DIR=$HOME/.config
CONFIG_DOT_DIR=$HOME/dotfiles/config
DOT_DIR=$HOME/dotfiles
FONTS_DIR=$HOME/dotfiles/fonts

install_extra_packages=1
install_nvim=1
while getopts ":en" opt; do
  case ${opt} in
    e) 
       install_extra_packages=0
       ;;
    n) 
       install_nvim=0
       ;;
    \?)
       echo "Invalid option: -$OPTARG" 1>&2
       exit 1
       ;;
  esac
done

_yay(){
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

_nvm(){
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
    source $HOME/.bashrc
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    nvm install node --lts
}

base_packages() {
	sudo pacman -Syy --noconfirm
	sudo pacman -S bat fzf unzip viewnior\
        scrot clang arandr fd ripgrep zsh alacritty\
        neovim tmux font-manager gnome-themes-extra pcmanfm\
        pavucontrol git-delta --noconfirm
    _nvm
    _yay
    # Rust
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
}

config_dirs_link() {
	local src=$CONFIG_DOT_DIR
	local dst=$CONFIG_DIR
    rm -fr $CONFIG_DIR
    mkdir $CONFIG_DIR
	ln -s $src/i3 $dst/i3
	ln -s $src/alacritty $dst/alacritty
	ln -s $src/gtk-3.0 $dst/gtk-3.0
    if [[ $install_nvim -eq 1 ]]; then
        ln -s $src/nvim $dst/nvim
    fi
    i3 reload
}

terminal(){
    # change shell
    sudo chsh -s $(which zsh) $(whoami)
    # Set gobal env variables
    echo $'EDITOR=nvim\nTERMINAL=alacritty' | sudo tee -a /etc/environment
    # OMZ
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    ln -s -f $DOT_DIR/zshrc $HOME/.zshrc
    # OMT
    pushd $HOME
    git clone https://github.com/gpakosz/.tmux.git
    ln -s -f .tmux/.tmux.conf
    cp .tmux/.tmux.conf.local .
    popd
    # p10k
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    ln -s -f $DOT_DIR/p10k.zsh $HOME/.p10k.zsh
}

fonts(){
    font-manager -i $FONTS_DIR/*
    yay -S noto-fonts-emoji-apple --noconfirm
    i3 reload
}

extra_conf(){
    ln -s -f $DOT_DIR/gtkrc-2.0 $HOME/.gtkrc-2.0
    # i3 lock service
    sudo ln -s -f $DOT_DIR/i3lock.service /etc/systemd/system/i3lock.service
    sudo systemctl enable i3lock.service
    # clang-format 2-4 spaces indent
    ln -s -f $DOT_DIR/clang-format $HOME/.clang-format
    # gitconfig
    sudo ln -s -f $DOT_DIR/gitconfig $HOME/.gitconfig
    # keyboard win-alt on mechanical
    ln -s -f $DOT_DIR/Xkeymap $HOME/.Xkeymap
    ln -s -f $DOT_DIR/xinitrc $HOME/.xinitrc
}

extra_packages(){
    yay -S microsoft-edge-stable-bin ledger-live-bin --noconfirm
    sudo pacman -S telegram-desktop bitwarden --noconfirm
}

main(){
	base_packages
    fonts
	config_dirs_link
	terminal
    extra_conf
    if [[ $install_extra_packages -eq 1 ]]; then
        extra_packages
    fi
}

main


