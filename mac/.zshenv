# Essential PATH additions
# Initialize PATH with system defaults
PATH="/usr/bin:/bin:/usr/sbin:/sbin"

# Add directories in order of precedence (highest first)
PATH="$HOME/.cargo/bin:$PATH"                    # Rust binaries
PATH="$HOME/.local/bin:$PATH"                    # User local binaries
PATH="/opt/homebrew/opt/llvm/bin:$PATH"          # LLVM tools
PATH="/opt/homebrew/opt/m4/bin:$PATH"            # M4 macro processor
PATH="/usr/local/opt/openjdk/bin:$PATH"          # OpenJDK
PATH="/usr/local/sbin:$PATH"                     # Local system binaries

# Basic environment variables
export EDITOR='emacs -nw'
export LESSOPEN="| pygmentize -g %s"
export LESS='-R'
export HOMEBREW_EDITOR="emacs -nw -q"
export RIPGREP_CONFIG_PATH="${HOME}/.config/ripgreprc"

# OpenAI API key (consider moving this to a more secure location if needed)
export OPENAI_API_KEY=$(cat ~/.openai/emacs-key.txt)

# Homebrew setup (if needed before other tools)
eval "$(/opt/homebrew/bin/brew shellenv)"

# Pyenv setup (minimal version)
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

# Essential build-related variables
export LDFLAGS="-L/opt/homebrew/opt/llvm@12/lib -L/opt/homebrew/lib -L/opt/homebrew/lib/gcc/11"
export CPPFLAGS="-I/opt/homebrew/opt/llvm@12/include -I/opt/homebrew/include"
export LD_LIBRARY_PATH="/opt/homebrew/lib/:/opt/homebrew/lib/gcc/11/"
export LIBRARY_PATH="/opt/homebrew/lib/:/opt/homebrew/lib/gcc/11/"
