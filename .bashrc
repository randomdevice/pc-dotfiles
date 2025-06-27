#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# ENV VARS
export LIBVIRT_DEFAULT_URI='qemu:///system'
export PATH=$HOME/.local/bin:$PATH
export ANDROID_HOME=$HOME/Android/Sdk

# ALIASES
alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

alias vim=nvim
alias vi=nvim
alias backup='~/.config/scripts/backup.bash'
alias bitpass='python3 $HOME/secure_files/hash/sha256.py'
. "$HOME/.cargo/env"

eval "$(starship init bash)"
