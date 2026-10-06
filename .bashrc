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
export LD_LIBRARY_PATH=$HOME/.local/DataGrip/lib:$LD_LIBRARY_PATH
export CHROME_EXECUTABLE=/usr/bin/chromium
export NODE_PATH="$HOME/.local/mcp-servers/node_modules:$NODE_PATH"
export MCP_ACCESS_DIRS=$HOME/Development/
export EDITOR=nvim

# ALIASES
alias devpod='DOCKER_CMD=podman devcontainer'
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
alias ssh_to_ec2='ssh -i ~/.ssh/cis5960-mgmt-keypair.pem ubuntu@ec2-16-59-210-227.us-east-2.compute.amazonaws.com'

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

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# BEGIN CUDA 12.9 CONFIGURATION
export CUDA_HOME=/opt/cuda
export PATH="$CUDA_HOME/bin:$PATH"
export LD_LIBRARY_PATH="$CUDA_HOME/lib64${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
export CUDACXX="$CUDA_HOME/bin/nvcc"
export NVCC_CCBIN=/usr/bin/g++
export CC=/usr/bin/gcc
export CXX=/usr/bin/g++
# END CUDA 12.9 CONFIGURATION

# LIBTORCH CONFIGURATION
export LIBTORCH="/opt/libtorch"
export CMAKE_PREFIX_PATH="$LIBTORCH${CMAKE_PREFIX_PATH:+:$CMAKE_PREFIX_PATH}"
export LD_LIBRARY_PATH="$LIBTORCH/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
export TORCH_CUDA_ARCH_LIST="8.9"
# END LIBTORCH CONFIGURATION

# Project 2 Build Commands
alias rebuild='cmake -S . -B build \
  -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_PREFIX_PATH="$LIBTORCH" \
  -DCMAKE_CXX_COMPILER=/usr/bin/g++ \
  -DCUDAToolkit_ROOT=/opt/cuda \
  -DCUDA_TOOLKIT_ROOT_DIR=/opt/cuda \
  -DCUDA_NVCC_EXECUTABLE=/opt/cuda/bin/nvcc \
  -DTORCH_CUDA_ARCH_LIST=8.9'
alias remake='cmake --build build --parallel "$(nproc)"'
# Project 2
