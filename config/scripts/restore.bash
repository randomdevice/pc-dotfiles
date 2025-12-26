LOCAL_DIR=$(pwd)/../../
DOTFILE_REPO=$LOCAL_DIR

# Exit immediately on intermediate command abort
# set -e

function yes_or_no {
    while true; do
        read -p "$* [y/n]: " yn
        case $yn in
            [Yy]*) 
                return 0 
                ;;  
            [Nn]*) 
                echo "Skipping..."
                return 1 
                ;;
        esac
    done
}

function confirm_dotfile {
    echo "Assuming DOTFILE_REPO is: $DOTFILE_REPO"
    echo "Please correct in script if needed."
    yes_or_no "Continue?" || return 1
    echo "Running from $DOTFILE_REPO"
}

function update_backup {
    echo "Installing backup script"
    yes_or_no "Continue?" || return 1
    pushd $DOTFILE_REPO
        git lfs install
        git lfs pull 
    popd
    cp -v "$DOTFILE_REPO/config/scripts/backup.bash" "$HOME/.config/scripts/backup.bash"
}

function update_restore {
    echo "Installing restore script"
    yes_or_no "Continue?" || return 1
    pushd $DOTFILE_REPO
        git lfs install
        git lfs pull 
    popd
    cp -v "$DOTFILE_REPO/config/scripts/restore.bash" "$HOME/.config/scripts/restore.bash"
}

function install_yay {
    echo "Installing yay for AUR packages:"
    yes_or_no "Continue?" || return 1
    echo "Installing..."
    pushd "$HOME/repo_local"
      # Using && here ensures git clone only runs if pacman succeeds
      sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git
      cd yay
      makepkg -si
    popd
}

function setup_udisks {
    echo "Setup directories for disk mounts."
    yes_or_no "Continue?" || return 1
    sudo mkdir -p "/run/media/$USER/primarystorage"
    sudo mkdir -p "/run/media/$USER/backup"
    sudo setfacl -m g:wheel:rwx "/run/media/$USER/primarystorage"
    sudo setfacl -m g:wheel:rwx "/run/media/$USER/backup"
    sudo cp -r "$DOTFILE_REPO/10-udisks2.rules" /etc/polkit-1/rules.d/10-udisks2.rules
}

function setup_basics {
    echo "Installing basic packages for setup (pkglist-base.txt):"
    cat "$DOTFILE_REPO/lists/pkglist-base.txt"
    grep -vxFf "$DOTFILE_REPO/lists/pkglist-base.txt" "$DOTFILE_REPO/pkglist.txt" > "$DOTFILE_REPO/lists/pkglist-final.txt"
    yes_or_no "Continue?" || return 1
    sudo pacman -S --needed $(comm -12 <(pacman -Slq | sort) <(sort "$DOTFILE_REPO/lists/pkglist-base.txt"))
    yay -S --needed localsend-bin
    yay -S --needed rofi-emoji-git
    yay -S --needed rofi-wayland
    yay -S --needed pacseek 
    yay -S --needed wlogout
    yay -S --needed wttrbar
}

function setup_configs {
    echo "Installing local configs, bashrc, and theme:"
    yes_or_no "Continue?" || return 1
    pushd $DOTFILE_REPO
        git lfs install
        git lfs pull 
    popd
    cp -rv "$DOTFILE_REPO/config/"* "$HOME/.config"
    cp -rv "$DOTFILE_REPO/.bashrc" "$HOME/.bashrc"
    sudo cp -rv "$DOTFILE_REPO/usr/share/sddm/themes/sugar-dark" /usr/share/sddm/themes/
}

function setup_containers {
    echo "Installing packages for containers (pkglist-containers.txt):"
    cat "$DOTFILE_REPO/lists/pkglist-containers.txt"
    grep -vxFf "$DOTFILE_REPO/lists/pkglist-containers.txt" "$DOTFILE_REPO/lists/pkglist-final.txt" > "$DOTFILE_REPO/lists/pkglist-final-tmp.txt"
    mv "$DOTFILE_REPO/lists/pkglist-final-tmp.txt" "$DOTFILE_REPO/lists/pkglist-final.txt"
    yes_or_no "Continue?" || return 1
    sudo yay -S --needed $(comm -12 <(pacman -Slq | sort) <(sort "$DOTFILE_REPO/lists/pkglist-containers.txt"))
}

function setup_dev {
    echo "Installing packages for dev libs (pkglist-dev.txt):"
    cat "$DOTFILE_REPO/lists/pkglist-dev.txt"
    grep -vxFf "$DOTFILE_REPO/lists/pkglist-dev.txt" "$DOTFILE_REPO/lists/pkglist-final.txt" > "$DOTFILE_REPO/lists/pkglist-final-tmp.txt"
    mv "$DOTFILE_REPO/lists/pkglist-final-tmp.txt" "$DOTFILE_REPO/lists/pkglist-final.txt"
    yes_or_no "Continue?" || return 1
    sudo yay -S --needed $(comm -12 <(pacman -Slq | sort) <(sort "$DOTFILE_REPO/lists/pkglist-dev.txt"))
}

function setup_gaming {
    echo "Installing packages for dev libs (pkglist-gaming.txt):"
    cat "$DOTFILE_REPO/lists/pkglist-gaming.txt"
    grep -vxFf "$DOTFILE_REPO/lists/pkglist-gaming.txt" "$DOTFILE_REPO/lists/pkglist-final.txt" > "$DOTFILE_REPO/lists/pkglist-final-tmp.txt"
    mv "$DOTFILE_REPO/lists/pkglist-final-tmp.txt" "$DOTFILE_REPO/lists/pkglist-final.txt"
    yes_or_no "Continue?" || return 1
    sudo yay -S --needed $(comm -12 <(pacman -Slq | sort) <(sort "$DOTFILE_REPO/lists/pkglist-gaming.txt"))
}

function setup_virt {
    echo "Installing packages for dev libs (pkglist-virt.txt):"
    cat "$DOTFILE_REPO/lists/pkglist-virt.txt"
    grep -vxFf "$DOTFILE_REPO/lists/pkglist-virt.txt" "$DOTFILE_REPO/lists/pkglist-final.txt" > "$DOTFILE_REPO/lists/pkglist-final-tmp.txt"
    mv "$DOTFILE_REPO/lists/pkglist-final-tmp.txt" "$DOTFILE_REPO/lists/pkglist-final.txt"
    yes_or_no "Continue?" || return 1
    sudo yay -S --needed $(comm -12 <(pacman -Slq | sort) <(sort "$DOTFILE_REPO/lists/pkglist-virt.txt"))
}

function setup_usr {
    echo "Installing user packages (pkglist-final.txt):"
    cat "$DOTFILE_REPO/lists/pkglist-final.txt"
    yes_or_no "Continue?" || return 1
    sudo yay -S --needed $(comm -12 <(pacman -Slq | sort) <(sort "$DOTFILE_REPO/lists/pkglist-final.txt"))
    # Extra AUR packages
    yay -S --needed - < "$DOTFILE_REPO/pkglist-aur.txt"
}

function setup_rust {
    echo "Installing Rust"
    yes_or_no "Continue?" || return 1
    # Install Rust
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
}

install_yay
confirm_dotfile
update_backup
update_restore
setup_udisks
setup_basics
setup_configs
setup_containers
setup_dev
setup_gaming
setup_virt
setup_usr
setup_rust

echo "Setup completed successfully!"
