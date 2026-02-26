#!/bin/bash
set -e

# Prevent interactive prompts during installation
export DEBIAN_FRONTEND=noninteractive
export NEEDRESTART_MODE=a

# Compile Emacs from source with modern features

EMACS_DIR="emacs"

echo "Installing Emacs build dependencies..."
sudo apt update
sudo apt install -y \
  build-essential \
  libgnutls28-dev \
  libtree-sitter-dev \
  libjansson-dev \
  libmagickwand-dev \
  libtiff-dev \
  libgif-dev \
  libjpeg-dev \
  libpng-dev \
  libxpm-dev \
  libncurses-dev \
  libgtk-3-dev \
  texinfo \
  libgccjit-12-dev \
  gcc-12 \
  g++-12 \
  autoconf \
  automake

# Set GCC 12 as default for native compilation
export CC=/usr/bin/gcc-12
export CXX=/usr/bin/g++-12

echo "Cloning Emacs from master branch..."
cd /tmp
rm -rf "${EMACS_DIR}"
git clone --depth 1 --branch master https://git.savannah.gnu.org/git/emacs.git "${EMACS_DIR}"
cd "${EMACS_DIR}"

echo "Running autogen..."
./autogen.sh

echo "Configuring Emacs with imagemagick, tree-sitter, and native compilation..."
./configure \
  --with-imagemagick \
  --with-tree-sitter \
  --with-native-compilation=aot \
  --with-json \
  --with-mailutils

echo "Building Emacs (this may take a while)..."
make -j$(nproc)

echo "Installing Emacs..."
sudo make install

echo "Cleaning up..."
cd /tmp
rm -rf "${EMACS_DIR}"

echo "Emacs installed successfully from master branch!"
emacs --version
