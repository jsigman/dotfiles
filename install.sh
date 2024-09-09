#!/bin/bash
set -ex

# coder dotfiles -y https://github.com/jsigman/dotfiles.git

# Preamble
CLONE_DIR="$HOME/dotfiles"
BACKUP_DIR="$HOME/dotfiles_backup"
REPO_URL="git@github.com:jsigman/dotfiles.git"

# Clone the dotfiles repo with submodules
git clone --recurse-submodules "$REPO_URL" "$CLONE_DIR"

# Make a backup directory for existing dotfiles
mkdir -p "$BACKUP_DIR"

# Navigate to the clone directory and run the install script
cd "$CLONE_DIR" && python3 install.py

# Install Starship
curl -sS https://starship.rs/install.sh | sh -s -- -y

# Install other utilities
sudo add-apt-repository ppa:rmescandon/yq

# Function to check if NVIDIA drivers are installed
check_nvidia_drivers() {
    if ! command -v nvidia-smi &>/dev/null; then
        echo "NVIDIA drivers are not installed."
        return 1
    else
        echo "NVIDIA drivers are already installed."
        return 0
    fi
}

# Function to get the latest NVIDIA driver version
get_latest_nvidia_driver() {
    apt-cache search nvidia-driver | grep -oP 'nvidia-driver-[0-9]+' | sort -V | tail -n1
}

# Check and install NVIDIA drivers if needed
if ! check_nvidia_drivers; then
    echo "Installing NVIDIA drivers..."
    latest_driver=$(get_latest_nvidia_driver)
    sudo apt update
    sudo apt install -y $latest_driver
    echo "Installed $latest_driver"
else
    echo "NVIDIA drivers are already installed. Skipping installation."
fi

# Configure Nvidia for display
sudo nvidia-xconfig --preserve-busid --enable-all-gpus

sudo apt update && sudo apt install -y pandoc direnv tmux texlive-latex-base yq rustc cargo fd-find build-essential sqlite3

# update rust:
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source $HOME/.cargo/env
rustup update

# install fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# Switch to multi-user target and then back to graphical target
sudo systemctl isolate multi-user.target
sudo systemctl isolate graphical.target

# Enable dcvserver service
sudo systemctl enable dcvserver

if ! command -v docker >/dev/null 2>&1; then
    echo "Installing docker"
    # Add Docker's official GPG key:
    sudo apt-get update
    sudo apt-get install ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

    # Update and install
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
fi

# Install docker-compose
if ! command -v docker-compose >/dev/null 2>&1; then
    echo "Installing docker-compose"
    sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
fi

sudo systemctl start docker
sudo usermod -aG docker $USER

# For file syncing
OCAML_VERSION=5.2.0 ./install_unison.sh

# DVC > 3
sudo snap remove dvc
sudo snap install dvc --classic --channel=stable

# NPM and language servers
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
. $HOME/.nvm/nvm.sh && nvm install --lts

~/.emacs.d/install_lsp_servers.sh

echo "Installation and configuration completed."
