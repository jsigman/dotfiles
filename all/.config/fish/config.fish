# ~/.config/fish/config.fish

starship init fish | source
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
eval $HOME/anaconda3/bin/conda "shell.fish" "hook" $argv | source
# <<< conda initialize <<<


source $HOME/.docker/init-fish.sh || true # Added by Docker Desktop
