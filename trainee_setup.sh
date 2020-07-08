#!/bin/bash

nosudo() {
    if [ "$EUID" -eq 0 ]
    then 
        echo "Do not run as sudo"
        exit 1
    fi
}

create_temporary_zone() {
    cd `mktemp -d`
}

download_apt_dependencies() {
    # First let's update and upgrade this system
    sudo apt update && sudo apt upgrade -y
    sudo apt install wget gcc g++ curl vim cmake git zsh fonts-powerline python3-pip -y
}

install_zsh() {
    # Install Oh-My-Zsh for the Z-Shell
    wget -O oh-my-zsh-install.sh https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
    chmod +x oh-my-zsh-install.sh
    ./oh-my-zsh-install.sh --unattended --skip-chsh

    # Set zsh as he default shell
    sudo chsh -s $(which zsh)

    # Change some preferences of the Z-Shell
    sed 's/^ZSH_THEME=.*/ZSH_THEME="agnoster"/g' ~/.zshrc > ~/.tmpzshrc
    mv ~/.tmpzshrc ~/.zshrc
}

install_vscode() {
    sudo snap install --classic code

    # Install extensions
    EXTENSIONS=( "twxs.cmake" "ms-vscode.cmake-tools" "ms-python.python" "ms-vscode.cpptools" "eamodio.gitlens" )

    for extension in "${EXTENSIONS[@]}"
    do
        code --install-extension $extension
    done
}

main() {
    currentDir=`pwd`
    nosudo
    create_temporary_zone
    download_apt_dependencies
    install_zsh
    install_vscode
    cd $currentDir
}

main $@
exit 0
