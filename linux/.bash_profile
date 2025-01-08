bind 'set completion-ignore-case on'

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

export PYENV_VERSION=3.12.0
eval "$(pyenv init -)"

eval "$(starship init bash)"
eval "$(direnv hook bash)"

direnv reload 2>/dev/null
export RIPGREP_CONFIG_PATH="${HOME}/.config/ripgreprc"
alias ls='ls --color=auto'

alias sso='aws sso login --no-browser'

shopt -s histappend # append to history file, don't overwrite it
HISTSIZE=10000
HISTFILESIZE=10000
HISTTIMEFORMAT="%d/%m/%y %T "

# Redirect Bash history to a persistent location
export HISTFILE=/data/ds/users/jsigman/.bash_history

PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND" # immediate access to history from all terms

export LESSOPEN="| pygmentize -g %s"
export LESS='-R'

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

export FZF_CTRL_T_COMMAND=""
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# if .profile exists, source it
if [ -f "$HOME/.profile" ]; then
    source "$HOME/.profile"
fi
