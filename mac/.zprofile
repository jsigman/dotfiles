eval "$(/opt/homebrew/bin/brew shellenv)"

vterm_printf() {
    if [ -n "$TMUX" ] && ([ "${TERM%%-*}" = "tmux" ] || [ "${TERM%%-*}" = "screen" ]); then
        # Tell tmux to pass the escape sequences through
        printf "\ePtmux;\e\e]%s\007\e\\" "$1"
    elif [ "${TERM%%-*}" = "screen" ]; then
        # GNU screen (screen, screen-256color, screen-256color-bce)
        printf "\eP\e]%s\007\e\\" "$1"
    else
        printf "\e]%s\e\\" "$1"
    fi
}
vterm_prompt_end() {
    vterm_printf "51;A$(whoami)@$(hostname):$(pwd)"
}
setopt PROMPT_SUBST
PROMPT=$PROMPT'%{$(vterm_prompt_end)%}'

export PATH="/usr/local/sbin:$PATH"
export PATH="/usr/local/opt/openjdk/bin:$PATH"

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

export PYENV_VERSION=3.8.13
eval "$(pyenv init -)"

export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh" # This loads nvm

eval "$(starship init zsh)"
eval "$(direnv hook zsh)"

direnv reload 2>/dev/null

alias brew86="arch -x86_64 /usr/local/bin/brew"
alias pyenv86="arch -x86_64 pyenv"

# to build emacs
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/llvm@12/lib"
export LDFLAGS="-L/opt/homebrew/lib $LDFLAGS"
export LDFLAGS="-L/opt/homebrew/lib/gcc/11 $LDFLAGS"
export CPPFLAGS="-I/opt/homebrew/opt/llvm@12/include"
export CPPFLAGS="-I/opt/homebrew/include $CPPFLAGS"
export LD_LIBRARY_PATH="/opt/homebrew/lib/:/opt//homebrew/lib/gcc/11/"
export LIBRARY_PATH="/opt/homebrew/lib/:/opt//homebrew/lib/gcc/11/"

# shortcut
alias gitroot='cd $(git rev-parse --show-toplevel)'

export RIPGREP_CONFIG_PATH="${HOME}/.config/ripgreprc"
echo ran bash profile

# auto completion for stuff like makefiles
autoload -U compinit
compinit

# for emacs style word boundaries
autoload -U select-word-style
select-word-style bash

if [ -d "$HOME/Applications/Emacs.app/Contents/MacOS/bin/" ]; then
    export PATH="$HOME/Applications/Emacs.app/Contents/MacOS/bin:$PATH"
fi

# set environment variable from file
export OPENAI_API_KEY=$(cat ~/.openai/emacs-key.txt)
alias ls='ls --color=auto'

export LESSOPEN="| pygmentize -g %s"
export LESS='-R'

