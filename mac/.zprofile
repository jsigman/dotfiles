eval "$(/opt/homebrew/bin/brew shellenv)"

export EDITOR='emacs -nw'
export PATH="/usr/local/sbin:$PATH"
export PATH="/usr/local/opt/openjdk/bin:$PATH"

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh" # This loads nvm

# to build emacs
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/llvm@12/lib"
export LDFLAGS="-L/opt/homebrew/lib $LDFLAGS"
export LDFLAGS="-L/opt/homebrew/lib/gcc/11 $LDFLAGS"
export CPPFLAGS="-I/opt/homebrew/opt/llvm@12/include"
export CPPFLAGS="-I/opt/homebrew/include $CPPFLAGS"
export LD_LIBRARY_PATH="/opt/homebrew/lib/:/opt//homebrew/lib/gcc/11/"
export LIBRARY_PATH="/opt/homebrew/lib/:/opt//homebrew/lib/gcc/11/"

export RIPGREP_CONFIG_PATH="${HOME}/.config/ripgreprc"

if [ -d "$HOME/Applications/Emacs.app/Contents/MacOS/bin/" ]; then
    export PATH="$HOME/Applications/Emacs.app/Contents/MacOS/bin:$PATH"
fi

# set environment variable from file
export OPENAI_API_KEY=$(cat ~/.openai/emacs-key.txt)

# Created by `pipx` on 2024-02-01 09:45:16
export PATH="$PATH:/Users/jsigman/.local/bin"
alias sso='aws sso login'

# fzf
export FZF_DEFAULT_OPTS="--bind ctrl-t:ignore $FZF_DEFAULT_OPTS"
