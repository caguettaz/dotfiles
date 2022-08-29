#!/usr/bin/env bash

[[ $- != *"i"* ]] && return 0

# Eternal bash history. Taken from http://stackoverflow.com/questions/9457233/unlimited-bash-history
# ---------------------
export HISTFILESIZE=-1
export HISTSIZE=-1
export HISTTIMEFORMAT="[%F %T] "
# Change the file location because certain bash sessions truncate .bash_history file upon close.
# http://superuser.com/questions/575479/bash-history-truncated-to-500-lines-on-each-login
export HISTFILE=~/.bash_eternal_history
# Force prompt to write history after every command.
# http://superuser.com/questions/20900/bash-history-loss
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

# Load RVM, if you are using it
[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm

# Add rvm gems and nginx to the path
#export PATH=$PATH:~/.gem/ruby/1.8/bin:/opt/nginx/sbin

# Path to the bash it configuration
export BASH_IT=$HOME/.bash_it

# Lock and Load a custom theme file
# location /.bash_it/themes/
export BASH_IT_THEME='bobby'

# Your place for hosting Git repos. I use this for private repos.
#export GIT_HOSTING='git@git.domain.com'

# Set the path nginx
#export NGINX_PATH='/opt/nginx'

# Don't check mail when opening terminal.
unset MAILCHECK


# Change this to your console based IRC client of choice.

export IRC_CLIENT='irssi'

# Set this to the command you use for todo.txt-cli
export TODO="t"

# Set this to false to turn off version control status checking within the prompt for all themes
export SCM_CHECK=true

# Set vcprompt executable path for scm advance info in prompt (demula theme)
# https://github.com/xvzf/vcprompt
#export VCPROMPT_EXECUTABLE=~/.vcprompt/bin/vcprompt

# Load Bash It
source $BASH_IT/bash_it.sh

BASHRC_D=$HOME/.bashrc.d
if [ -d "$BASHRC_D" ]; then
	for f in $HOME/.bashrc.d/*; do
		source "$f"
	done
fi

export EDITOR=/etc/alternatives/editor
export VISUAL="$EDITOR"

export PATH="$PATH:$HOME/bin:$HOME/.local/bin"
source $HOME/.bash_aliases

function swap()         
{
    local TMPFILE=tmp.$$
    mv "$1" $TMPFILE
    mv "$2" "$1"
    mv $TMPFILE "$2"
}

shopt -s extglob

#source $HOME/.bash_nvcrap
#export LD_LIBRARY_PATH=/usr/local/cuda-6.5/lib64:$LD_LIBRARY_PATH


#suppress Gtk-WARNING bullshit
#see https://askubuntu.com/questions/505594/how-to-stop-gedit-and-other-programs-from-outputting-gtk-warnings-and-the-like
_supress() {
  eval "$1() { \$(which $1) \"\$@\" 2>&1 | tr -d '\r' | grep -v \"$2\"; }"
}

#_supress meld "Gtk"

export JAUNY_CACHE="$HOME/.jauny_cache"

#gitg is too broken for simply greping out stuff, suppress everything
gitg() { $(which gitg) "$@" 2>/dev/null; }

BASHRC_LOCAL="$HOME/.bashrc_local"

if [[ -e "$BASHRC_LOCAL" ]]; then
    . "$BASHRC_LOCAL"
fi

TAOCL_CACHE=/var/cache/misc/taocl
function taocl() {
    #Check that there is a cached version updated by cron - otherwise, bail silently.
    [ -f "$TAOCL_CACHE" ] || return
    printf '\n***Tip from '"'"'The art of command line'"'"'***\n'
    cat "$TAOCL_CACHE" |
    sed '/cowsay[.]png/d' |
    pandoc -f markdown -t html |
    xmlstarlet fo --html --dropdtd |
    xmlstarlet sel -t -v "(html/body/ul/li[count(p)>0])[$RANDOM mod last()+1]" |
    xmlstarlet unesc | fmt -80 | iconv -t US -c
    printf '******\n'
}

taocl
