LOCAL_DIR=$(pwd)/../
sudo pacman -S --needed $(comm -12 <(pacman -Slq | sort) <(sort $LOCAL_DIR/pkglist.txt))
yay -S --needed - < $LOCAL_DIR/pkglist-aur.txt
