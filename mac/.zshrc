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
function coder-start() {
    coder start $CODER_USERNAME/$CODER_INSTANCE_NAME
}
function dcv-connect() {
    open -a "DCV Viewer" --args localhost:8443
    coder port-forward $CODER_USERNAME/$CODER_INSTANCE_NAME --tcp 8443:8443
}

alias ls='ls --color=auto'

export LESSOPEN="| pygmentize -g %s"
export LESS='-R'

export PYENV_VERSION=3.8.13
eval "$(pyenv init -)"

eval "$(direnv hook zsh)"
direnv reload 2>/dev/null

eval "$(starship init zsh)"

autoload -U compinit
compinit

autoload -U select-word-style
select-word-style bash

source /Users/jsigman/.docker/init-zsh.sh || true # Added by Docker Desktop
alias gitroot='cd $(git rev-parse --show-toplevel)'

# Created by `pipx` on 2024-02-01 09:45:16
export PATH="$PATH:/Users/jsigman/.local/bin"
export PATH="/opt/homebrew/opt/m4/bin:$PATH"
export HOMEBREW_EDITOR="emacs -nw -q"

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)
