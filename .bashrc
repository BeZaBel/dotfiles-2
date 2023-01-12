#!/bin/bash
# Configured by Itsnexn (itsnexn.xyz)
# Repository: https://github.com/itsnexn/dotfiles

# shellcheck disable=SC1090

case $- in
	*i*) ;; # interactive
	*) return ;;
esac

# --------------------------------- Options ------------------------------------

stty werase undef
shopt -s autocd
shopt -s checkwinsize  # enables $COLUMNS and $ROWS
shopt -s expand_aliases
shopt -s globstar
shopt -s dotglob
shopt -s extglob

# -------------------------- Local Helper Functions ----------------------------

_have() { type "$1" > /dev/null 2>&1; }
_source_if() { [[ -r "$1" ]] && . "$1"; }

# ---------- Environment variables, Aliases and Other configurations -----------

SHRC_DIR="$HOME/.config/sh"
_source_if "$SHRC_DIR/env"
_source_if "$SHRC_DIR/aliases"
_source_if "$SHRC_DIR/custom"

# ---------------------------------- PATH --------------------------------------

_check_path()
{
	[ -n "$1" ] || return 1
	[ -d "$1" ] || return 1
	PATH=${PATH//:${1}:/:} # remove if it's already somewhere in the middle
	PATH=${PATH/#${1}:/}   # remove if it's at the beginning of the path
	PATH=${PATH/%:${1}/}   # remove if it's at the end of the path
	return 0
}

pathappend() {
	for i in "$@"
	do
		_check_path "$i" && export PATH="${PATH:+"$PATH:"}$i"
	done
}

pathprepend() {
	for i in "$@"
	do
		_check_path "$i" && export PATH="$i${PATH:+":${PATH}"}"
	done
}

pathprepend \
	"$GOPATH/bin" \
	"$SCRIPTS"

pathappend \
	~/.local/bin \
	~/.local/scripts \
	/opt/jython/bin \
	/usr/bin/vendor_perl \
	/usr/lib/jvm/default/bin \
	/opt/android-sdk/platform-tools \

# --------------------------------- History ------------------------------------

export HISTFILE="${XDG_DATA_HOME:-$HOME/.local/share}/bash_hist"
export HISTSIZE=1000
export HISTIGNORE="clear:ls:pwd:exit:sudo reboot:cd -:cd .."

# ------------------------------ Key bindings ----------------------------------

set -o vi # enable vi keys
bind '\C-w:unix-filename-rubout'

# ------------------------------- Completion -----------------------------------

# archlinux bash-completion pkg
[[ -r "/usr/share/bash-completion/bash_completion" ]] && . "/usr/share/bash-completion/bash_completion"

_have gh     && . <(gh completion -s bash)
_have pandoc && . <(pandoc --bash-completion)
_have docker && _source_if "$HOME/.local/share/docker/completion" # d

# ------------------------------- Bash Prompt ----------------------------------

if [ -f /usr/share/git/completion/git-prompt.sh ]
then
	export GIT_PS1_SHOWDIRTYSTATE='y'
	export GIT_PS1_SHOWSTASHSTATE='y'
	export GIT_PS1_SHOWUNTRACKEDFILES='y'
	export GIT_PS1_DESCRIBE_STYLE='contains'
	export GIT_PS1_SHOWUPSTREAM='auto'

	source "/usr/share/git/completion/git-prompt.sh"
else
	__git_ps1() { :; }
fi

__ps1()
{
	# colors
	g='\[\e[32m\]' # green
	b='\[\e[34m\]' # blue
	bd='\[\e[1m\]' # bold
	rt='\[\e[0m\]' # reset

	PS1="$g$bd\u$rt$g@$bd\H$rt:$b\w$rt$(__git_ps1 " (%s)")$ "
}

PROMPT_COMMAND="__ps1"
