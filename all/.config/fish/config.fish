# Function to handle terminal printing with conditions
function vterm_printf;
    if begin; [  -n "$TMUX" ]  ; and  string match -q -r "screen|tmux" "$TERM"; end
        # tell tmux to pass the escape sequences through
        printf "\ePtmux;\e\e]%s\007\e\\" "$argv"
    else if string match -q -- "screen*" "$TERM"
        # GNU screen (screen, screen-256color, screen-256color-bce)
        printf "\eP\e]%s\007\e\\" "$argv"
    else
        printf "\e]%s\e\\" "$argv"
    end
end

if [ "$INSIDE_EMACS" = 'vterm' ]
    function clear
        vterm_printf "51;Evterm-clear-scrollback";
        tput clear;
    end
end

function fish_title
    hostname
    echo ":"
    prompt_pwd
end

function vterm_prompt_end;
    vterm_printf '51;A'(whoami)'@'(hostname)':'(pwd)
end
functions --copy fish_prompt vterm_old_fish_prompt
function fish_prompt --description 'Write out the prompt; do not replace this. Instead, put this at end of your file.'
    # Remove the trailing newline from the original prompt. This is done
    # using the string builtin from fish, but to make sure any escape codes
    # are correctly interpreted, use %b for printf.
    printf "%b" (string join "\n" (vterm_old_fish_prompt))
    vterm_prompt_end
end

function find_file
    set -q argv[1]; or set argv[1] "."
    vterm_cmd find-file (realpath "$argv")
end

function say
    vterm_cmd message "%s" "$argv"
end

# Convert remote function
function remote
    set -l remote_host "$REMOTE_HOST"
    set -l remote_path "$REMOTE_PATH"

    ssh -t "$REMOTE_HOST" "cd $REMOTE_PATH && exec \$SHELL -l"
end

# Convert coder-start function
function coder-start
    coder start $CODER_USERNAME/$CODER_INSTANCE_NAME
end

# Convert dcv-connect function
function dcv-connect
    coder port-forward $CODER_USERNAME/$CODER_INSTANCE_NAME --tcp 8443:8443 > /dev/null &
    open -a "DCV Viewer" --args localhost:8443
end

# Aliases
alias ls='ls --color=auto'

# if on mac run the following:
if test -d /opt/homebrew/bin
    # Add Homebrew to PATH
    set -gx PATH /opt/homebrew/bin $PATH
    # Correctly use command substitution for setting shell environment variables
    eval (env /opt/homebrew/bin/brew shellenv)
end

alias gitroot='cd (git rev-parse --show-toplevel)'

# Export statements
set -gx LESSOPEN "| pygmentize -g %s"
set -gx LESS '-R'
set -gx PYENV_VERSION 3.8.13
set PATH $PATH /Users/jsigman/.local/bin


# Initialization scripts adaptation (needs manual intervention for exact paths and commands)
# Example for pyenv, adjust according to specific init scripts provided or manually
pyenv init - | source
direnv hook fish | source
starship init fish | source

export PATH="/usr/local/sbin:$PATH"
export PATH="/usr/local/opt/openjdk/bin:$PATH"

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh" # This loads nvm

# to build emacs
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/llvm@12/lib"
export LDFLAGS="-L/opt/homebrew/lib $LDFLAGS"
export LDFLAGS="-L/opt/homebrew/lib/gcc/11 $LDFLAGS"
export CPPFLAGS="-I/opt/homebrew/opt/llvm@12/include"
export CPPFLAGS="-I/opt/homebrew/include $CPPFLAGS"
export LD_LIBRARY_PATH="/opt/homebrew/lib/:/opt//homebrew/lib/gcc/11/"
export LIBRARY_PATH="/opt/homebrew/lib/:/opt//homebrew/lib/gcc/11/"

export RIPGREP_CONFIG_PATH="$HOME/.config/ripgreprc"

if test -d "$HOME/Applications/Emacs.app/Contents/MacOS/bin/"
    set -gx PATH $HOME/Applications/Emacs.app/Contents/MacOS/bin $PATH
end

# set environment variable from file
export OPENAI_API_KEY=$(cat ~/.openai/emacs-key.txt)

# Created by `pipx` on 2024-02-01 09:45:16
export PATH="$PATH:/Users/jsigman/.local/bin"


# Note: For initializing other tools like pyenv, direnv, you'll need to manually find or adapt initialization code for fish
echo "Ran fish configuration"
