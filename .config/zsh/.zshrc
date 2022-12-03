#!/usr/bin/env zsh
# This file is part of Itsnexn's dotfiles.
#
# Repository: https://github.com/itsnexn/dotfiles
# LICENSE:    MIT (https://opensource.org/licenses/MIT)


# Source configurations
SH_CONFIGDIR="${XDG_CONFIG_HOME:-$HOME/.config}/sh"

[ -f "$SH_CONFIGDIR/aliases" ] && source "$SH_CONFIGDIR/aliases"
[ -f "$SH_CONFIGDIR/custom"  ] && source "$SH_CONFIGDIR/custom"

# KeyBindings ==================================================================
bindkey -v            # Use vim key bindings
unsetopt flow_control # Make ctrl-q work again!
export WORDCHARS=''   # CTRL+w: remove by steps.
export KEYTIMEOUT=1

# Make sure that the terminal is in application mode when zle is active, since
# only then values from $terminfo are valid
# Source: https://github.com/ohmyzsh/ohmyzsh/blob/master/lib/key-bindings.zsh
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init() {
        echoti smkx
    }
    function zle-line-finish() {
        echoti rmkx
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi

# Start typing + [Up-Arrow] - fuzzy find history forward
if [[ -n "${terminfo[kcuu1]}" ]]; then
    autoload -U up-line-or-beginning-search
    zle -N up-line-or-beginning-search

    bindkey -M viins "${terminfo[kcuu1]}" up-line-or-beginning-search
    bindkey -M vicmd "${terminfo[kcuu1]}" up-line-or-beginning-search
fi

# Start typing + [Down-Arrow] - fuzzy find history backward
if [[ -n "${terminfo[kcud1]}" ]]; then
    autoload -U down-line-or-beginning-search
    zle -N down-line-or-beginning-search

    bindkey -M viins "${terminfo[kcud1]}" down-line-or-beginning-search
    bindkey -M vicmd "${terminfo[kcud1]}" down-line-or-beginning-search
fi

# [Shift-Tab] - move through the completion menu backwards
if [[ -n "${terminfo[kcbt]}" ]]; then
    bindkey -M viins "${terminfo[kcbt]}" reverse-menu-complete
    bindkey -M vicmd "${terminfo[kcbt]}" reverse-menu-complete
fi

# [Space] - don't do history expansion
bindkey ' ' magic-space

# [Backspace] - delete backward
bindkey -M viins '^?' backward-delete-char
bindkey -M vicmd '^?' backward-delete-char

# [Delete] - delete forward
if [[ -n "${terminfo[kdch1]}" ]]; then
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

# Init =========================================================================
export ZVM_INIT_MODE=sourcing

# Select menu style
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'

setopt interactive_comments
setopt prompt_subst
setopt autocd   # Automatically cd into typed directory.
stty stop undef # Disable ctrl-s to freeze terminal.

# Completion
zmodload zsh/complist
autoload -U compinit && compinit

command_not_found_handler () { # Minimal command not found handler
    printf "$(tput setaf 1)$(tput bold)%s$(tput sgr0) command not found!\n" "$1" >&2
    return 127
}

autoload -U colors && colors # Enable colors
eval "$(starship init zsh)" # Start starship prompt

# Load Plugin's ================================================================
# loading plugins manually it's much faster than your plugin manager :p

# -- Zsh vi mode
# https://github.com/jeffreytse/zsh-vi-mode
if [ -d "${ZDOTDIR}/zsh-vi-mode" ]; then
    source "${ZDOTDIR}/zsh-vi-mode/zsh-vi-mode.zsh"
    ZVM_VI_HIGHLIGHT_BACKGROUND=8
fi

# -- Zsh Autosuggestions
# https://github.com/zsh-users/zsh-autosuggestions
[ -d "${ZDOTDIR}/zsh-autosuggestions" ] && \
    source "${ZDOTDIR}/zsh-autosuggestions/zsh-autosuggestions.zsh"
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#7A818E"


# -- Zsh Syntax Highlighting
# https://github.com/zdharma-continuum/fast-syntax-highlighting
if [ -d "${ZDOTDIR}/zsh-syntax-highlighting" ]; then
    source "${ZDOTDIR}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    ZSH_HIGHLIGHT_STYLES[comment]=fg=8
    ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
fi
