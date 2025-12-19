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

export PATH

# Basic environment variables
export EDITOR='emacs -nw'
export LESSOPEN="| pygmentize -f terminal -l %s 2>/dev/null || pygmentize -f terminal -g %s"
export LESS='-R -X -F --tabs=4'

export HOMEBREW_EDITOR="emacs -nw -q"
export RIPGREP_CONFIG_PATH="${HOME}/.config/ripgreprc"

# OpenAI API key (consider moving this to a more secure location if needed)
export OPENAI_API_KEY=$(cat ~/.openai/emacs-key.txt)

# Homebrew setup (needed for non-login shells like vterm)
eval "$(/opt/homebrew/bin/brew shellenv)"

# CRITICAL: Add curl AFTER brew shellenv to ensure Homebrew's curl (8.17.0) takes precedence
# over system curl (8.7.1). This is required for gptel's AWS Bedrock backend (needs curl >= 8.9)
export PATH="/opt/homebrew/opt/curl/bin:$PATH"

# Essential build-related variables
export LDFLAGS="-L/opt/homebrew/opt/llvm@12/lib -L/opt/homebrew/lib -L/opt/homebrew/lib/gcc/11"
export CPPFLAGS="-I/opt/homebrew/opt/llvm@12/include -I/opt/homebrew/include"
export LD_LIBRARY_PATH="/opt/homebrew/lib/:/opt/homebrew/lib/gcc/11/"
export LIBRARY_PATH="/opt/homebrew/lib/:/opt/homebrew/lib/gcc/11/"
