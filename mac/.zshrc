eval "$(starship init zsh)"

# vterm_printf function for vterm compatibility
vterm_printf() {
    if [ -n "$TMUX" ] && ([ "${TERM%%-*}" = "tmux" ] || [ "${TERM%%-*}" = "screen" ]); then
        printf "\ePtmux;\e\e]%s\007\e\\" "$1"
    elif [ "${TERM%%-*}" = "screen" ]; then
        printf "\eP\e]%s\007\e\\" "$1"
    else
        printf "\e]%s\e\\" "$1"
    fi
}

# Function to update vterm's directory
vterm_prompt_end() {
    vterm_printf "51;A$(whoami)@$(hostname):$(pwd)"
}

# Add functions to precmd_functions array
precmd_functions+=(vterm_prompt_end)

# Message passing functionality for vterm
vterm_cmd() {
    local vterm_elisp
    vterm_elisp=""
    while [ $# -gt 0 ]; do
        vterm_elisp="$vterm_elisp""$(printf '"%s" ' "$(printf "%s" "$1" | sed -e 's|\\|\\\\|g' -e 's|"|\\"|g')")"
        shift
    done
    vterm_printf "51;E$vterm_elisp"
}

# Utility functions for vterm
find_file() {
    vterm_cmd find-file "$(realpath "${@:-.}")"
}

say() {
    vterm_cmd message "%s" "$*"
}

# Check if inside Emacs vterm
if [[ "$INSIDE_EMACS" = 'vterm' ]] \
    && [[ -n ${EMACS_VTERM_PATH} ]] \
    && [[ -f ${EMACS_VTERM_PATH}/etc/emacs-vterm-zsh.sh ]]; then
    source ${EMACS_VTERM_PATH}/etc/emacs-vterm-zsh.sh
fi
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
eval "$(direnv hook zsh)"
direnv reload 2>/dev/null
# Allow # comments in interactive mode
setopt INTERACTIVE_COMMENTS

# Completion and word style
autoload -U compinit && compinit
autoload -U select-word-style && select-word-style bash

# Docker Desktop (only if it exists)
[ -f /Users/jsigman/.docker/init-zsh.sh ] && source /Users/jsigman/.docker/init-zsh.sh

# FZF configuration
export FZF_CTRL_T_COMMAND=""
# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

if command -v eza >/dev/null 2>&1; then
  alias ls='eza'
  alias ll='eza -l'      # Long listing format
  alias la='eza -la'     # Include hidden files
  alias lt='eza --tree'  # Tree view
fi
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
