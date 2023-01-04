#!/bin/zsh
# Configured by Itsnexn (itsnexn.xyz)
# Repository: https://github.com/itsnexn/dotfiles

# shellcheck disable=SC1090

case $- in
	*i*) ;; # interactive
	*) return ;; 
esac

# --------------------------------- Options ------------------------------------

stty stop undef
setopt prompt_subst
setopt interactive_comments  # allow comments even in interactive shells.
setopt autocd                # Automatically cd into typed directory.
unsetopt flow_control        # Make ctrl-q work again!

export WORDCHARS=''          # CTRL+w: remove by steps.
export KEYTIMEOUT=1

# -------------------------- Local Helper Functions ----------------------------

# local helper function's
_have() { type "$1" > /dev/null 2>&1; }
_source_if() { [[ -r "$1" ]] && . "$1"; }

# ---------- Environment variables, Aliases and Other configurations -----------

SHRC_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/sh"
_source_if "$SHRC_DIR/env"
_source_if "$SHRC_DIR/aliases"
_source_if "$SHRC_DIR/custom"

# -------------------------------- History -------------------------------------

export HISTFILE="${XDG_DATA_HOME:-$HOME/.local/share}/zsh_hist"
export HISTSIZE=1000
export HISTORY_IGNORE="(clear|ls|pwd|exit|sudo reboot|cd -|cd ..)"

# ----------------------------- key bindings -----------------------------------

bindkey -v # use vim key bindings

# Make sure that the terminal is in application mode when zle is active, since
# only then values from $terminfo are valid
# Source: https://github.com/ohmyzsh/ohmyzsh/blob/master/lib/key-bindings.zsh
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} ))
then
	zle-line-init() { echoti smkx; }
	zle-line-finish() { echoti rmkx; }
	zle -N zle-line-init
	zle -N zle-line-finish
fi

# [Up-Arrow] - fuzzy find history forward
if [[ -n "${terminfo[kcuu1]}" ]]
then
	autoload -U up-line-or-beginning-search
	zle -N up-line-or-beginning-search
	bindkey -M viins "${terminfo[kcuu1]}" up-line-or-beginning-search
	bindkey -M vicmd "${terminfo[kcuu1]}" up-line-or-beginning-search
fi

# [Down-Arrow] - fuzzy find history backward
if [[ -n "${terminfo[kcud1]}" ]]
then
	autoload -U down-line-or-beginning-search
	zle -N down-line-or-beginning-search
	bindkey -M viins "${terminfo[kcud1]}" down-line-or-beginning-search
	bindkey -M vicmd "${terminfo[kcud1]}" down-line-or-beginning-search
fi

# [Home] - Go to beginning of line
if [[ -n "${terminfo[khome]}" ]]
then
	bindkey -M viins "${terminfo[khome]}" beginning-of-line
	bindkey -M vicmd "${terminfo[khome]}" beginning-of-line
fi

# [Shift-Tab] - move through the completion menu backwards
if [[ -n "${terminfo[kcbt]}" ]]
then
	bindkey -M viins "${terminfo[kcbt]}" reverse-menu-complete
	bindkey -M vicmd "${terminfo[kcbt]}" reverse-menu-complete
fi

# [Space] - don't do history expansion
bindkey ' ' magic-space

# [Backspace] - delete backward
bindkey -M viins '^?' backward-delete-char
bindkey -M vicmd '^?' backward-delete-char

# [Delete] - delete forward
if [[ -n "${terminfo[kdch1]}" ]]
then
	bindkey -M viins "${terminfo[kdch1]}" delete-char
	bindkey -M vicmd "${terminfo[kdch1]}" delete-char
else
	bindkey -M viins "^[[3~" delete-char
	bindkey -M vicmd "^[[3~" delete-char
	bindkey -M viins "^[3;5~" delete-char
	bindkey -M vicmd "^[3;5~" delete-char
fi

# [Ctrl-Delete] - delete whole forward-word
bindkey -M viins '^[[3;5~' kill-word
bindkey -M vicmd '^[[3;5~' kill-word

# [C-RightArrow] - move forward one word
bindkey -M viins '^[[1;5C' forward-word
bindkey -M vicmd '^[[1;5C' forward-word

# [C-LeftArrow] - move backward one word
bindkey -M viins '^[[1;5D' backward-word
bindkey -M vicmd '^[[1;5D' backward-word

# ---------------------------------- Styles ------------------------------------

# Select menu style
zstyle ':completion:*' menu select
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'

if [ -f /usr/share/git/completion/git-prompt.sh ]
then
	export GIT_PS1_SHOWDIRTYSTATE='y'
	export GIT_PS1_SHOWSTASHSTATE='y'
	export GIT_PS1_SHOWUNTRACKEDFILES='y'
	export GIT_PS1_DESCRIBE_STYLE='contains'
	export GIT_PS1_SHOWUPSTREAM='auto'

	source /usr/share/git/completion/git-prompt.sh
else
	__git_ps1() { :; }
fi

__ps1()
{
	PS1="%{$fg[green]%}%B%n%b%{$fg[green]%}@%B%m%b%{$reset_color%}:%{${fg[blue]}%}%B%~%b%{$reset_color%}$(__git_ps1 " (%s)")$ "
}

precmd() { __ps1; }

# ------------------------------- shell Init -----------------------------------

# minimal command not found handler
command_not_found_handler()
{
	printf "$(tput setaf 1)$(tput bold)%s$(tput sgr0) command not found!\n" "$1" >&2
	return 127
}

# completion
zmodload zsh/complist
autoload -U compinit && compinit
autoload -U colors && colors
_have gh && source <(gh completion -s zsh)

# --------------------------------- plugins ------------------------------------

ZSH_PLUGIN_DIR="$XDG_DATA_HOME/zsh"
# -- Zsh Autosuggestions
# https://github.com/zsh-users/zsh-autosuggestions
if [ -d "${ZSH_PLUGIN_DIR}/zsh-autosuggestions" ]
then
	source "${ZSH_PLUGIN_DIR}/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# -- Zsh Syntax Highlighting
# https://github.com/zdharma-continuum/fast-syntax-highlighting
if [ -d "${ZSH_PLUGIN_DIR}/zsh-syntax-highlighting" ]
then
	source "${ZSH_PLUGIN_DIR}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
	export ZSH_HIGHLIGHT_STYLES["comment"]="fg=8"
	export ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
fi
