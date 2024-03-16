#!/bin/bash

ESC=$(printf '\033') 

big_info() {
  printf "${ESC}[34m
==============================
$1
==============================\n${ESC}[m"
}

info () {
  printf "\r  [ ${ESC}[00;34mINFO${ESC}[0m ] $1\n"
}

success () {
  printf "\r${ESC}[2K  [  ${ESC}[00;32mOK${ESC}[0m  ] $1\n"
}

error() {
  printf "[${ESC}[00;31mERROR${ESC}[0m] $1\n"
}


make_links() {

    mkdir -p $HOME/.config/
    ln -sf $(pwd)/wezterm $HOME/.config

    DOTFILES="""
        shell/.zshrc
        shell/.zprofile
        shell/paths
        shell/aliases
        shell/zinit
        shell/env
        shell/prompt
        """

    info "start create dotfile links"

    for dotfile in $DOTFILES
    do
        info "link $(pwd)/$dotfile to $HOME"
        ln -fns $(pwd)/$dotfile $HOME
    done

    success "Sucess create dotfile links"
}


homebrew() {
    info "check homebrew"

    type brew > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        info "homebrew already installed!"
        return 0
    fi

    info "brew not found. try to install homebrew..."

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || exit 0 
    
    success "success install homebrew"

    info "Install 'brew' dependencies..."
    brew bundle --global -v -f

    success "success Install 'brew' dependencies"
}


git () {
    info "check git"

    type git > /dev/null 2>&1 
    if [ $? -eq 0 ] ; then
        info "git already installed!"
        return 0
    fi

    info "git not found. try to install git..."

    brew install git

    success "success install homebrew"
}


install_rustup() {
    info "check rustup"

    if type rustup > /dev/null 2>&1; then
        info "rustup already installed!"
    else
        info "install rustup..."

        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

        success "success install rustup" 
    fi
}

install_python() {
    info "check python"

    # VERSION2="2.7.17"
    VERSION3="3.8.10"

    type pyenv > /dev/null 2>&1 || brew install pyenv

    # pyenv install $VERSION2
    pyenv install $VERSION3 && pyenv global $VERSION3 && success "success install python" && return 0

    info "python already installed!"
    
}


install_node() {
    info "check node"

    type nodenv > /dev/null 2>&1 || brew install nodenv

    VERSION="20.11.1"
    nodenv install $VERSION && nodenv global $VERSION && success "success install node" && return 0

    info "node already installed!"
}


install_golang() {
    info "check golang"

    type go > /dev/null 2>&1 || {
        brew install go # TODO: バージョン指定してインストールできるようにしたい
        success "success install golang"
        return 0
    }

    info "golang already installed!"
}


install_docker() {

    
    type docker > /dev/null 2>&1 \
        || brew install --cask docker \
        && success "success install docker" \
        && return 1 # MEMO: Install docker-desktop 

    info "already installed docker"
}



main() {
    big_info "start bootstrap!"

    make_links
    homebrew
    git


    big_info "install languages"
    install_rustup
    install_python
    install_node
    install_golang

    big_info "install dev tools"

    install_docker


    success "Finished!!"
}



main
