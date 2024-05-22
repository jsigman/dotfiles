#!/bin/bash

# Define the version and URLs
VERSION="2.53.5"
URL="https://github.com/bcpierce00/unison/releases/download/v${VERSION}/unison-${VERSION}-ubuntu-x86_64-static.tar.gz"
TAR_FILE="unison-${VERSION}-ubuntu-x86_64-static.tar.gz"

# Download the release
wget $URL -O ~/Downloads/$TAR_FILE

# Navigate to the Downloads directory
cd ~/Downloads

# Extract the tar.gz file
tar -xzf $TAR_FILE

# Navigate to the extracted directory
cd unison-${VERSION}-ubuntu-x86_64-static

# Install Unison binaries
sudo cp bin/unison /usr/local/bin/
sudo cp bin/unison-fsmonitor /usr/local/bin/

# Clean up
cd ..
rm -rf unison-${VERSION}-ubuntu-x86_64-static
rm $TAR_FILE

echo "Unison ${VERSION} installed successfully!"
