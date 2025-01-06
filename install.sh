#!/bin/bash
set -ex

# coder dotfiles -y https://github.com/jsigman/dotfiles.git

# Check for unattended-upgrades process
if pgrep -x "unattended-upgrade" >/dev/null; then
    echo "The unattended-upgrades process is currently running."
    echo "Please wait for it to complete or stop it gracefully using:"
    echo "    sudo systemctl stop unattended-upgrades"
    echo "Then restart this script."
    exit 1
fi

# Proceed with the script
echo "No conflicting processes detected. Proceeding with installation..."

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
sudo add-apt-repository ppa:rmescandon/yq -y

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
NVIDIA_DRIVER_VERSION="nvidia-driver-560"

# Check and install NVIDIA drivers if needed
if ! check_nvidia_drivers; then
    echo "Installing NVIDIA drivers..."
    sudo apt update
    if [ -z "$NVIDIA_DRIVER_VERSION" ]; then
        NVIDIA_DRIVER_VERSION=$(get_latest_nvidia_driver)
    fi
    sudo apt install -y $NVIDIA_DRIVER_VERSION
    echo "Installed $NVIDIA_DRIVER_VERSION"
else
    echo "NVIDIA drivers are already installed. Skipping installation."
fi

# Configure Nvidia for display
sudo nvidia-xconfig --preserve-busid --enable-all-gpus

# Install necessary packages
sudo apt update && sudo apt install -y \
    pandoc direnv tmux texlive-latex-base yq rustc cargo fd-find build-essential sqlite3

# Update Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"
rustup update

# Install fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# Switch to multi-user target and back to graphical target
sudo systemctl isolate multi-user.target
sudo systemctl isolate graphical.target

# Enable dcvserver service
sudo systemctl enable dcvserver

# File syncing
OCAML_VERSION=5.2.0 ./install_unison.sh

# Install pyenv
curl https://pyenv.run | bash
$HOME/.pyenv/bin/pyenv install 3.12.4

# Install DVC
sudo snap remove dvc
sudo snap install dvc --classic --channel=stable

# Install NVM and language servers
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
. "$HOME/.nvm/nvm.sh" && nvm install --lts

~/.emacs.d/install_lsp_servers.sh

echo "Installation and configuration completed."
