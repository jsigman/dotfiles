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
sudo apt update && sudo apt install -y pandoc direnv tmux texlive-latex-base

# Add here the installation of Fish shell
sudo apt install -y fish

# Configure Nvidia
sudo nvidia-xconfig --preserve-busid --enable-all-gpus

# Switch to multi-user target and then back to graphical target
sudo systemctl isolate multi-user.target
sudo systemctl isolate graphical.target

# Enable dcvserver service
sudo systemctl enable dcvserver

# Add Fish shell to the list of allowed shells (if not already present)
if ! grep -q "^$(which fish)$" /etc/shells; then
  echo "$(which fish)" | sudo tee -a /etc/shells
fi

# Change the default shell to Fish for the current user
chsh -s $(which fish)

echo "Installation and configuration completed."
