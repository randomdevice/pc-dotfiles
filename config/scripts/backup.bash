#!/bin/bash

# --- Configuration ---
DOTFILE_REPO="$HOME/repo_local/pc-dotfiles"
DATE=$(date +'%Y-%m-%d %H:%M')

# Core UI and System configs identified for your Hyprland/Virt setup
CONFIGS_TO_BACKUP=(
    "hypr" "waybar" "rofi" "dunst" "electron-flags.conf" "scripts" "volume-notif" "wlogout" "swww" 
    "cliphist" "nvim" "nwg-displays" "nwg-look" "kitty" "gtk-2.0"
    "gtk-3.0" "gtk-4.0" "fontconfig" "mimeapps.list"
    "xsettingsd"
)

# --- Functions ---
function yes_or_no {
    while true; do
        read -p "$* [y/n]: " yn
        case $yn in
            [Yy]*) return 0 ;;
            [Nn]*) return 1 ;;
        esac
    done
}

function git_push {
    pushd "$DOTFILE_REPO" > /dev/null
    header "Git Status Summary"
    git status --short
    echo ""
    yes_or_no "Confirm: Commit and push these changes?" && \
    git add -A . && \
    git commit -m "chore: backup configs ($DATE)" && \
    git push
    popd > /dev/null
}

function header {
    echo -e "\n\e[1;34m>> $1\e[0m"
}

# Generates a list of other packages on the system that were not curated
function generate_final_pkglist {
    grep -vxFf "$DOTFILE_REPO/lists/pkglist-base.txt" "$DOTFILE_REPO/pkglist.txt" | \
    grep -vxFf "$DOTFILE_REPO/lists/pkglist-containers.txt" | \
    grep -vxFf "$DOTFILE_REPO/lists/pkglist-dev.txt" | \
    grep -vxFf "$DOTFILE_REPO/lists/pkglist-gaming.txt" | \
    grep -vxFf "$DOTFILE_REPO/lists/pkglist-virt.txt" > "$DOTFILE_REPO/lists/pkglist-final.txt"
}

# --- Execution ---

header "Creating directory structure"
mkdir -p "$DOTFILE_REPO/config"
mkdir -p "$DOTFILE_REPO/usr/share/sddm/themes/"

header "Backing up Package Lists"
pacman -Qqe > "$DOTFILE_REPO/pkglist.txt"
pacman -Qqem > "$DOTFILE_REPO/pkglist-aur.txt"
flatpak list --app --columns=application > "$DOTFILE_REPO/pkglist-flatpak.txt"
generate_final_pkglist
echo "Lists updated."

header "Syncing Selected .config Folders"
for dir in "${CONFIGS_TO_BACKUP[@]}"; do
    if [ -e "$HOME/.config/$dir" ]; then
        # rsync -av: archive mode, verbose
        # --delete: removes files in repo if they were deleted in source
        rsync -av --delete "$HOME/.config/$dir" "$DOTFILE_REPO/config/"
    else
        echo "Skipping $dir: Not found in ~/.config"
    fi
done

header "Syncing System Files (Sudo)"
cp -v "$HOME/.bashrc" "$DOTFILE_REPO/.bashrc"
sudo cp -v /etc/polkit-1/rules.d/10-udisks2.rules "$DOTFILE_REPO/10-udisks2.rules"
# Syncing SDDM theme
sudo rsync -av --delete /usr/share/sddm/themes/sugar-dark/ "$DOTFILE_REPO/usr/share/sddm/themes/sugar-dark/"

header "Final Review"
if yes_or_no "Proceed to Git deployment?"; then
    git_push
else
    echo "Backup completed locally only."
fi
