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



commnad_check() {
    if type $1 > /dev/null 2>&1; then
        success "$1"
    else
        error "$1"
    fi
}

check() {
    big_info "install checking..."

    COMMANDS=(rustup cargo pyenv python node nodenv go docker)

    for com in ${COMMANDS[@]}; do 
        commnad_check $com
    done
}

main() {
    check
}


main