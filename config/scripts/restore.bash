LOCAL_DIR=$(pwd)/../../
DOTFILE_REPO=$HOME/repo_local/pc-dotfiles

sudo pacman -S --needed $(comm -12 <(pacman -Slq | sort) <(sort $LOCAL_DIR/pkglist.txt))
pushd $HOME/repo_local
sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
popd
yay -S --needed - < $LOCAL_DIR/pkglist-aur.txt
mkdir -p /run/media/$USER/primarystorage
mkdir -p /run/media/$USER/backup
setfacl -m g:wheel:rwx /run/media/$USER/primarystorage
setfacl -m g:wheel:rwx /run/media/$USER/backup
cp -rv $DOTFILE_REPO/config/* $HOME/.config 
cp -rv $DOTFILE_REPO/.bashrc $HOME/.bashrc
sudo cp -r $DOTFILE_REPO/10-udisks2.rules /etc/polkit-1/rules.d/10-udisks2.rules 
sudo cp -rv $DOTFILE_REPO/usr/share/sddm/themes/sugar-dark /usr/share/sddm/themes/sugar-dark
