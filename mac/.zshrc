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

function remote() {
    local remote_host="$REMOTE_HOST"
    local remote_path="$REMOTE_PATH"

    ssh -t "${REMOTE_HOST}" "cd ${REMOTE_PATH} && exec \$SHELL -l"
}

alias ls='ls --color=auto'

export LESSOPEN="| pygmentize -g %s"
export LESS='-R'

export PYENV_VERSION=3.8.13
eval "$(pyenv init -)"

eval "$(direnv hook zsh)"
direnv reload 2>/dev/null

eval "$(starship init zsh)"

# Faster loading of compinit. Checks for changes first before loading
zcompdir="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
mkdir -p "$zcompdir"
zcompfile="$zcompdir/.zcompdump"
if [[ -f "$zcompfile" && (! -z "$ZSH_COMPDUMP_REBUILD" || "$zcompfile" -ot "$HOME/.zshrc") ]]; then
    compinit
    compinit -C -d "$zcompfile"
else
    if [[ -f "$zcompfile" ]]; then
        source "$zcompfile"
    source 
    fi
fi

# Lazy loading select-word-style
function select-word-style-lazy() {
    autoload -U select-word-style
    select-word-style bash
    # redefine the function to the original one after first load
    function select-word-style-lazy() {
        select-word-style "$@"
    }
    select-word-style-lazy "$@"
}

# Alias the original function name to our lazy loader
alias select-word-style='select-word-style-lazy'

source /Users/jsigman/.docker/init-zsh.sh || true # Added by Docker Desktop

alias brew86="arch -x86_64 /usr/local/bin/brew"
alias pyenv86="arch -x86_64 pyenv"
alias gitroot='cd $(git rev-parse --show-toplevel)'
