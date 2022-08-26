alias xop="xdg-open"
alias glances="glances --theme-white"

function quickfind {
    >&2 printf 'Looking for *'"$1"'* [case-insensitive]...\n'
    find -iname '*'"$1"'*'
}

function build_switch {
    local curdir=$(pwd)
    local other
    local msg

    if [[ $curdir = *_build ]]; then
        other=${curdir%_build}
        msg="switching to source directory"
    else
        other="$curdir"_build
        msg="switching to build directory"
    fi

    if [[ ! -d $other ]]; then
        >&2 printf "$other does not exist, creating...\n"
        mkdir -p "$other"
    fi

    if [[ ! -d $other ]]; then
        >&2 printf "failed to create $other\n"
    else
        >&2 printf "$msg\n"
        cd "$other"
    fi
}

alias f="quickfind"
alias g="grep -ri"
alias nuke="rm -rf"
alias bs="build_switch"

function do_parent_nconfig {
    local curdir="$(pwd)"

    while [[ ! -f $curdir/Makefile ]]; do
        curdir="$curdir"/..
        if [[ $(realpath "$curdir") == / ]]; then
            break
        fi
    done

    if [[ ! -f $curdir/Makefile ]]; then
        printf "No makefile found in parent directories\n"
        return
    fi

    printf "Running 'make nconfig' in $curdir\n"
    make -C "$curdir" nconfig
}

function __rwhich {
    if [[ ! -e "$1" ]]; then
        return
    fi

    dn="$(dirname "$1")"
    cd "$dn"

    printf "%s" "$1"
   
    if [[ -L "$1" ]]; then
        printf " -> "
    fi

    printf "\n"

    local newpath="$(readlink "$1")"
    if [[ $? == 0 ]]; then
        __rwhich "$newpath"
    fi
}

function rwhich {
    (__rwhich "$(which "$1")")
}

alias nconfig="do_parent_nconfig"

BASH_ALIASES_LOCAL="$HOME/.bash_aliases_local"

if [[ -e "$BASH_ALIASES_LOCAL" ]]; then
    . "$BASH_ALIASES_LOCAL"
fi
