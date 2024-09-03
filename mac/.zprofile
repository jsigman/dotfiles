# Homebrew setup
eval "$(/opt/homebrew/bin/brew shellenv)"

# NVM setup
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"

# Add Emacs to PATH if it exists
if [ -d "$HOME/Applications/Emacs.app/Contents/MacOS/bin/" ]; then
    export PATH="$HOME/Applications/Emacs.app/Contents/MacOS/bin:$PATH"
fi

# Any other login-specific setup that isn't needed for every subshell
