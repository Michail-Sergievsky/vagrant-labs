#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#Enable Alias in separete file
if [ -f ~/.bash_aliases ]; then
. ~/.bash_aliases
fi

TERM=xterm

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias ll='ls --group-directories-first -lHAv'

export PS1='\[\033[00;30m\]\u@\[\033[00;34m\]\h \[\033[00;31m\]\W \$ \[\033[00m\]'

