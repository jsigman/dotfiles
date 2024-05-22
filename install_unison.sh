#!/bin/bash

set -ex

# Define the version and URLs
VERSION="2.53.5"
URL="https://github.com/bcpierce00/unison/releases/download/v${VERSION}/unison-${VERSION}-ubuntu-x86_64-static.tar.gz"
TAR_FILE="unison-${VERSION}-ubuntu-x86_64-static.tar.gz"
DOWNLOAD_DIR="$HOME/Downloads"

# Create the Downloads directory if it doesn't exist
mkdir -p $DOWNLOAD_DIR

# Download the release
wget $URL -O $DOWNLOAD_DIR/$TAR_FILE

# Check if the file was downloaded successfully
if [ ! -f $DOWNLOAD_DIR/$TAR_FILE ]; then
  echo "Failed to download the file."
  exit 1
fi

# Navigate to the Downloads directory
cd $DOWNLOAD_DIR

# Extract the tar.gz file
tar -xzf $TAR_FILE

# Check if the extraction was successful
if [ ! -d "$DOWNLOAD_DIR/unison-${VERSION}-ubuntu-x86_64-static" ]; then
  echo "Failed to extract the tar.gz file."
  exit 1
fi

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
