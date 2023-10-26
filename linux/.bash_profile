pathmunge () {
        if ! echo $PATH | /bin/egrep -q "(^|:)$1($|:)" ; then
           if [ "$2" = "after" ] ; then
              PATH=$PATH:$1
           else
              PATH=$1:$PATH
           fi
        fi
}

# TERMINAL -- TAB COMPLETEION, IGNORE CASE
bind 'set completion-ignore-case on'
source ~/.bashrc

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

export PYENV_VERSION=3.8.13
eval "$(pyenv init -)"

eval "$(starship init bash)"
eval "$(direnv hook bash)"
echo ran bash_profile

direnv reload 2>/dev/null

touch ~/.flags/bash-profile-$(date +%s)
