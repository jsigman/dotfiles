#!/bin/bash
set -ex

# Define the version and URLs
UNISON_VERSION="2.53.5"
SOURCE_URL="https://github.com/bcpierce00/unison/archive/refs/tags/v${UNISON_VERSION}.tar.gz"
SOURCE_TAR_FILE="unison-${UNISON_VERSION}.tar.gz"
DOWNLOAD_DIR="$HOME/Downloads"
BUILD_DIR="$DOWNLOAD_DIR/unison-build"

# Check if OCAML_VERSION is set
if [ -n "${OCAML_VERSION}" ]; then
    # Install OCaml and build dependencies
    sudo apt-get update
    sudo apt-get install -y ocaml opam build-essential

    # Initialize OPAM if not already initialized
    if [ ! -d "$HOME/.opam" ]; then
        opam init -a -y
    fi

    # Check if the specified OCaml version is already installed
    if ! opam switch list | grep -q "$OCAML_VERSION"; then
        opam switch create ${OCAML_VERSION}
    else
        opam switch ${OCAML_VERSION}
    fi
    eval $(opam env)

    # Create the Downloads and build directories if they don't exist
    mkdir -p $DOWNLOAD_DIR $BUILD_DIR

    # Download the source code
    wget $SOURCE_URL -O $DOWNLOAD_DIR/$SOURCE_TAR_FILE

    # Extract the source code
    tar -xzf $DOWNLOAD_DIR/$SOURCE_TAR_FILE -C $BUILD_DIR --strip-components=1

    # Build Unison
    cd $BUILD_DIR
    make

    # Install Unison
    sudo make install PREFIX=/usr/local

    # Clean up if CLEAN is set
    if [ "${CLEAN}" = "true" ]; then
        cd $DOWNLOAD_DIR
        rm -rf $BUILD_DIR $SOURCE_TAR_FILE
    fi

    echo "Unison ${UNISON_VERSION} compiled with OCaml ${OCAML_VERSION} and installed successfully!"
else
    # Binary installation logic
    BINARY_URL="https://github.com/bcpierce00/unison/releases/download/v${UNISON_VERSION}/unison-${UNISON_VERSION}-ubuntu-x86_64-static.tar.gz"
    BINARY_TAR_FILE="unison-${UNISON_VERSION}-ubuntu-x86_64-static.tar.gz"

    # Create the Downloads directory if it doesn't exist
    mkdir -p $DOWNLOAD_DIR

    # Download the release
    wget $BINARY_URL -O $DOWNLOAD_DIR/$BINARY_TAR_FILE

    # Check if the file was downloaded successfully
    if [ ! -f $DOWNLOAD_DIR/$BINARY_TAR_FILE ]; then
        echo "Failed to download the file."
        exit 1
    fi

    # Navigate to the Downloads directory
    cd $DOWNLOAD_DIR

    # Extract the tar.gz file
    tar -xzf $BINARY_TAR_FILE

    # Check if the binary exists
    if [ ! -f "$DOWNLOAD_DIR/bin/unison" ]; then
        echo "Failed to extract the tar.gz file or binary is missing."
        exit 1
    fi

    # Install Unison binary
    sudo cp bin/unison /usr/local/bin/

    # Clean up if CLEAN is set
    if [ "${CLEAN}" = "true" ]; then
        rm -rf bin $BINARY_TAR_FILE
    fi

    echo "Unison ${UNISON_VERSION} binary installed successfully!"
fi
