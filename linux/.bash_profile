bind 'set completion-ignore-case on'

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

export HISTFILE="$HOME/.bash_history"
PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND" # immediate access to history from all terms

export LESSOPEN="| pygmentize -f terminal -l %s 2>/dev/null || pygmentize -f terminal -g %s"
export LESS='-R -X -F --tabs=4'

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

# Time zone
export TZ="America/New_York"
