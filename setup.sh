#!/bin/bash

# Check if python exists on the path
if command -v python &>/dev/null; then
    python install.py
else
    # Configure pyenv
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    if command -v pyenv &>/dev/null; then
        eval "$(pyenv init --path)"
        # Now try to call python again
        if command -v python &>/dev/null; then
            python install.py
        else
            echo "Python is still not available. Please ensure you have a version installed with pyenv or install Python manually."
            echo $(pwd)
            exit 1
        fi
    else
        echo "pyenv is not installed or not available in the PATH. Please install pyenv or Python manually."
        exit 1
    fi
fi
