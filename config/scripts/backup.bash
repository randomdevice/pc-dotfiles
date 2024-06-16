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
pushd $DOTFILE_REPO
git add -A .
git lfs status
yes_or_no "Continue?"
git commit -m "chore: Updated config at $(date)"
git push
popd
}

DOTFILE_REPO=$HOME/repo_local/pc-dotfiles
mkdir -p $DOTFILE_REPO/config
mkdir -p $DOTFILE_REPO/usr/share/sddm/themes/sugar-dark
cp -rv $HOME/.config/* $DOTFILE_REPO/config/
sudo cp -rv /usr/share/sddm/themes/sugar-dark/* $DOTFILE_REPO/usr/share/sddm/themes/sugar-dark/
pacman -Qqe > $DOTFILE_REPO/pkglist.txt
pacman -Qqem > $DOTFILE_REPO/pkglist-aur.txt
flatpak list --app > $DOTFILE_REPO/pkglist-flatpak.txt

yes_or_no "Upload config to git?" && git_push

