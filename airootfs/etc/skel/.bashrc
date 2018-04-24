alias ls="ls --color=auto"
set_prompt () {
    Last_Command=$? # Must come first!
    Blue='\[\e[01;34m\]'
    White='\[\e[01;37m\]'
    Red='\[\e[01;31m\]'
    Green='\[\e[01;32m\]'
    Reset='\[\e[00m\]'
    FancyX='\342\234\227'
    Checkmark='\342\234\223'

    PS1="$White"
    if [[ $Last_Command != 0 ]]; then
        PS1+="\e[1;91m$FancyX $Last_Command "
    fi
    
    if [[ $EUID == 0 ]]; then
        PS1+="$Red\\u$Reset@\\h "
    else
        PS1+="$Blue\\u$Reset@\\h "
    fi
    
    PS1+="$Reset\\w \\\$ "
}
set_prompt
