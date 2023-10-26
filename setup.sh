#!/bin/bash

# Function to diagnose pyenv setup
diagnose_pyenv() {
    if [[ ! -d "$PYENV_ROOT" ]]; then
        echo "Error: PYENV_ROOT directory ($PYENV_ROOT) does not exist."
    else
        echo "PYENV_ROOT exists at $PYENV_ROOT"
        
        if [[ ! -d "$PYENV_ROOT/versions" ]]; then
            echo "Error: No versions directory in PYENV_ROOT. Seems like pyenv might not be installed correctly."
        else
            echo "Checking installed Python versions in pyenv..."
            PYENV_VERSIONS=$(ls "$PYENV_ROOT/versions")
            if [[ -z "$PYENV_VERSIONS" ]]; then
                echo "Error: No Python versions installed in pyenv."
            else
                echo "Installed Python versions:"
                echo "$PYENV_VERSIONS"
            fi
        fi
    fi
}

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
            echo "Python is still not available after setting up pyenv."
            diagnose_pyenv
            exit 1
        fi
    else
        echo "pyenv is not installed or not available in the PATH. Please install pyenv or Python manually."
        diagnose_pyenv
        exit 1
    fi
fi
