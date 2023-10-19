pathmunge () {
        if ! echo $PATH | /bin/egrep -q "(^|:)$1($|:)" ; then
           if [ "$2" = "after" ] ; then
              PATH=$PATH:$1
           else
              PATH=$1:$PATH
           fi
        fi
}

# check to see if there is any mention of starship bashrc.
# if there isn't then add it
if [ "1" -gt $(grep "starship" ${HOME}/.bashrc | wc -l) ]; then
    echo "eval \"\$(starship init bash)\"" >> ${HOME}/.bashrc
fi

# TERMINAL -- TAB COMPLETEION, IGNORE CASE
bind 'set completion-ignore-case on'

# eval "$(starship init bash)"
echo ran bash_profile
