#!/bin/bash

function yes_or_no {
    while true; do
        read -p "$* [y/n]: " yn
        case $yn in
            [Yy]*) return 0  ;;  
            [Nn]*) echo "Aborted" ; return  1 ;;
        esac
    done
}

function git_push {
pushd $LOCAL_CONFIG_REPO
git add -A .
git lfs status
yes_or_no "Continue?"
git commit -m "chore: Updated config at $(date)"
git push
popd
}

INSTALL_CONFIG_DIR=$HOME/.config/installed_packages
LOCAL_CONFIG_REPO=$HOME/repo_local/pc-dotfiles
pacman -Q > $INSTALL_CONFIG_DIR/pacman_installed.txt
yay -Q > $INSTALL_CONFIG_DIR/yay_installed.txt
flatpak list > $INSTALL_CONFIG_DIR/flatpak_installed.txt
cp -rv $HOME/.config/* $LOCAL_CONFIG_REPO/config/
cp -rv /usr/share/sddm/themes/sugar-dark/* $LOCAL_CONFIG_REPO/usr/share/sddm/themes/sugar-dark/

yes_or_no "Upload config to git?" && git_push

