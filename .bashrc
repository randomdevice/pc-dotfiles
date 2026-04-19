#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# KEEP TOKENS AND API KEYS HERE
source ~/.token

# ENV VARS
export LIBVIRT_DEFAULT_URI='qemu:///system'
export ANDROID_HOME=/opt/android-sdk
export PATH=$PATH:/opt/flutter/bin:$HOME/.local/bin:$HOME/.local/DataGrip/bin:/opt/cuda/bin:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator
export LD_LIBRARY_PATH=/opt/cuda/lib64:$HOME/.local/DataGrip/lib:$LD_LIBRARY_PATH
export CHROME_EXECUTABLE=/usr/bin/chromium
export NODE_PATH="$HOME/.local/mcp-servers/node_modules:$NODE_PATH"
export MCP_ACCESS_DIRS=$HOME/Development/
export EDITOR=nvim

# ALIASES
alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

alias vim=nvim
alias vi=nvim
alias backup='~/.config/scripts/backup.bash'
alias bitpass='python3 $HOME/secure_files/hash/sha256.py'
. "$HOME/.cargo/env"
alias launch_emu='QT_QPA_PLATFORM=xcb emulator -gpu host -avd Flutter_Android36 -no-snapshot-load'
alias upgrade_keyring='sudo pacman -Sy --needed archlinux-keyring'
alias refresh_heroic='refresh_heroic'
alias refresh_nvidia='sudo nvidia-ctk cdi generate --output=/var/run/cdi/nvidia.yaml'

function refresh_heroic {
  flatpak uninstall com.heroicgameslauncher.hgl
  flatpak uninstall --unused
  flatpak install com.heroicgameslauncher.hgl
}

eval "$(starship init bash)"

# opencode
export PATH=/home/agax/.opencode/bin:$PATH

# Added by Radicle.
export PATH="$PATH:/home/agax/.radicle/bin"
