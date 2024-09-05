# vterm-specific functions
vterm_printf() {
    if [ -n "$TMUX" ] && ([ "${TERM%%-*}" = "tmux" ] || [ "${TERM%%-*}" = "screen" ]); then
        printf "\ePtmux;\e\e]%s\007\e\\" "$1"
    elif [ "${TERM%%-*}" = "screen" ]; then
        printf "\eP\e]%s\007\e\\" "$1"
    else
        printf "\e]%s\e\\" "$1"
    fi
}

vterm_prompt_end() {
    vterm_printf "51;A$(whoami)@$(hostname):$(pwd)"
}

# Prompt configuration
setopt PROMPT_SUBST
PROMPT=$PROMPT'%{$(vterm_prompt_end)%}'

# Custom functions
function remote() {
    ssh -t "${REMOTE_HOST}" "cd ${REMOTE_PATH} && exec \$SHELL -l"
}

function coder-start() {
    coder start $CODER_USERNAME/$CODER_INSTANCE_NAME
}

function dcv-connect() {
    open -a "DCV Viewer" --args localhost:8443
    coder port-forward $CODER_USERNAME/$CODER_INSTANCE_NAME --tcp 8443:8443
}

# Aliases
alias ls='ls --color=auto'
alias gitroot='cd $(git rev-parse --show-toplevel)'
alias sso='aws sso login'

# Interactive shell configurations
eval "$(pyenv init -)"
eval "$(direnv hook zsh)"
direnv reload 2>/dev/null
eval "$(starship init zsh)"

# Completion and word style
autoload -U compinit && compinit
autoload -U select-word-style && select-word-style bash

# Docker Desktop (only if it exists)
[ -f /Users/jsigman/.docker/init-zsh.sh ] && source /Users/jsigman/.docker/init-zsh.sh

# FZF configuration
export FZF_CTRL_T_COMMAND=""
# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)
