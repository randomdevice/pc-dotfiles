LOCAL_DIR=$(pwd)/../../
DOTFILE_REPO=$LOCAL_DIR

# Exit immediately on intermediate command abort
# set -e

# Stylish header
function header {
    echo -e "\n\e[1;34m>> $1\e[0m"
}

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
    header "Confirm DOTFILE_REPO"
    echo "Assuming DOTFILE_REPO is: $DOTFILE_REPO"
    echo "Please correct in script if needed."
    yes_or_no "Continue?" || exit 1
    echo "Running from $DOTFILE_REPO"
}

function update_backup {
    header "Installing backup script"
    yes_or_no "Continue?" || return 1
    pushd $DOTFILE_REPO
        git lfs install
        git lfs pull 
    popd
    cp -v "$DOTFILE_REPO/config/scripts/backup.bash" "$HOME/.config/scripts/backup.bash"
}

function update_restore {
    header "Installing restore script"
    yes_or_no "Continue?" || return 1
    pushd $DOTFILE_REPO
        git lfs install
        git lfs pull 
    popd
    cp -v "$DOTFILE_REPO/config/scripts/restore.bash" "$HOME/.config/scripts/restore.bash"
}

function install_yay {
    header "Installing yay for AUR packages:"
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
    header "Setup directories for disk mounts."
    yes_or_no "Continue?" || return 1
    sudo mkdir -p "/run/media/$USER/primarystorage"
    sudo mkdir -p "/run/media/$USER/backup"
    sudo setfacl -m g:wheel:rwx "/run/media/$USER/primarystorage"
    sudo setfacl -m g:wheel:rwx "/run/media/$USER/backup"
    sudo cp -r "$DOTFILE_REPO/10-udisks2.rules" /etc/polkit-1/rules.d/10-udisks2.rules
}

# Generates a list of other packages on the system that were not curated
function generate_final_pkglist {
    grep -vxFf "$DOTFILE_REPO/lists/pkglist-base.txt" "$DOTFILE_REPO/pkglist.txt" | \
    grep -vxFf "$DOTFILE_REPO/lists/pkglist-containers.txt" | \
    grep -vxFf "$DOTFILE_REPO/lists/pkglist-dev.txt" | \
    grep -vxFf "$DOTFILE_REPO/lists/pkglist-gaming.txt" | \
    grep -vxFf "$DOTFILE_REPO/lists/pkglist-virt.txt" > "$DOTFILE_REPO/lists/pkglist-final.txt"
}

function setup_basics {
    header "Installing basic packages for setup (pkglist-base.txt):"
    cat "$DOTFILE_REPO/lists/pkglist-base.txt"
    yes_or_no "Continue?" || return 1
    yay -S --needed $(comm -12 <(pacman -Slq | sort) <(sort "$DOTFILE_REPO/lists/pkglist-base.txt"))
}

function setup_configs {
    header "Installing local configs, bashrc, and theme:"
    yes_or_no "Continue?" || return 1
    pushd $DOTFILE_REPO
        git lfs install
        git lfs pull 
    popd
    cp -rv "$DOTFILE_REPO/config/"* "$HOME/.config"
    cp -rv "$DOTFILE_REPO/.bashrc" "$HOME/.bashrc"
    sudo cp -rv "$DOTFILE_REPO/usr/share/sddm/themes/sugar-dark" /usr/share/sddm/themes/
    sudo mkdir -p /etc/sddm.conf.d && echo -e "[Theme]\nCurrent=sugar-dark" | sudo tee /etc/sddm.conf.d/theme.conf
}

function setup_containers {
    header "Installing packages for containers (pkglist-containers.txt):"
    cat "$DOTFILE_REPO/lists/pkglist-containers.txt"
    yes_or_no "Continue?" || return 1
    yay -S --needed $(comm -12 <(pacman -Slq | sort) <(sort "$DOTFILE_REPO/lists/pkglist-containers.txt"))
}

function setup_dev {
    header "Installing packages for dev libs (pkglist-dev.txt):"
    cat "$DOTFILE_REPO/lists/pkglist-dev.txt"
    yes_or_no "Continue?" || return 1
    yay -S --needed $(comm -12 <(pacman -Slq | sort) <(sort "$DOTFILE_REPO/lists/pkglist-dev.txt"))
}

function setup_gaming {
    header "Installing packages for dev libs (pkglist-gaming.txt):"
    cat "$DOTFILE_REPO/lists/pkglist-gaming.txt"
    yes_or_no "Continue?" || return 1
    yay -S --needed $(comm -12 <(pacman -Slq | sort) <(sort "$DOTFILE_REPO/lists/pkglist-gaming.txt"))
}

function setup_virt {
    header "Installing packages for dev libs (pkglist-virt.txt):"
    cat "$DOTFILE_REPO/lists/pkglist-virt.txt"
    yes_or_no "Continue?" || return 1
    yay -S --needed $(comm -12 <(pacman -Slq | sort) <(sort "$DOTFILE_REPO/lists/pkglist-virt.txt"))
}

function setup_usr {
    header "Installing user packages (pkglist-final.txt):"
    cat "$DOTFILE_REPO/lists/pkglist-final.txt"
    yes_or_no "Continue?" || return 1
    yay -S --needed $(comm -12 <(pacman -Slq | sort) <(sort "$DOTFILE_REPO/lists/pkglist-final.txt"))
    # Extra AUR packages
    yay -S --needed - < "$DOTFILE_REPO/pkglist-aur.txt"
}

function setup_flatpak {
    header "Installing flatpak packages (pkglist-flatpak.txt):"
    cat "$DOTFILE_REPO/pkglist-flatpak.txt"
    yes_or_no "Continue?" || return 1
    flatpak uninstall --unused
    flatpak install -y flathub $(grep -v '^#' $DOTFILE_REPO/pkglist-flatpak.txt)
}

function setup_rust {
    header "Installing Rust"
    yes_or_no "Continue?" || return 1
    # Install Rust
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
}

generate_final_pkglist
update_backup
update_restore
confirm_dotfile
install_yay
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
