#!/bin/bash

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
curl -sS https://starship.rs/install.sh | sh

# Install other utilities
sudo add-apt-repository ppa:rmescandon/yq
sudo apt update && sudo apt install -y pandoc direnv tmux texlive-latex-base yq

# Configure Nvidia
sudo nvidia-xconfig --preserve-busid --enable-all-gpus

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
  echo   "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |   sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

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

echo "Installation and configuration completed."
