export TERM="xterm-256color"
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

_has() {
  return $( whence $1 >/dev/null )
}

fpath=(~/.zsh/completion $fpath)
fpath+=~/.zsh/zfunc

# Lines configured by zsh-newuser-install
zstyle :compinstall filename '~/.zshrc'
setopt autocd beep extendedglob nomatch notify
bindkey -e
# End of lines configured by zsh-newuser-install

autoload -Uz compinit
compinit -C

setopt auto_param_slash
setopt mark_dirs
setopt list_types
setopt auto_menu
setopt auto_param_keys
setopt interactive_comments
setopt magic_equal_subst
setopt complete_in_word
setopt always_last_prompt
setopt print_eight_bit
setopt extended_glob
setopt globdots  # enable completion for dotfiles
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':completion:*:default' menu select=1
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters
zstyle ':completion:*:*files' ignored-patterns '*?.o' '*?~' '*\#'

## add color
autoload colors
colors
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# history option
###############################################################################
# History Configuration
##############################################################################
HISTSIZE=5000               # How many lines of history to keep in memory
HISTFILE=~/.zsh_history     # Where to save history to disk
SAVEHIST=5000               # Number of history entries to save to disk
HISTDUP=erase               # Erase duplicates in the history file
setopt appendhistory        # Append history to the history file (no overwriting)
setopt sharehistory         # Share history across terminals
setopt incappendhistory     # Immediately append to the history file, not just when a term is killed
setopt hist_ignore_dups
setopt hist_ignore_space
setopt histignorealldups

setopt list_packed
setopt pushd_ignore_dups

# no beep
setopt nolistbeep
setopt nobeep

## auto cd
setopt auto_cd
zstyle ':completion:*:cd:*' tag-order local-directories path-directories
zstyle ':completion:*:cd:*' ignore-parents parent pwd

## By default, zsh considers many characters part of a word (e.g., _ and -).
## Narrow that down to allow easier skipping through words via M-f and M-b.
export WORDCHARS='*?[]~&;!$%^<>'

export PATH="/usr/local/bin:/usr/local/sbin:$PATH"
export PATH="$(brew --prefix)/bin:$PATH"

f () {
    TF_PREVIOUS=$(fc -ln -1 | tail -n 1);
    TF_CMD=$(
        TF_ALIAS=f
        TF_SHELL_ALIASES=$(alias)
        PYTHONIOENCODING=utf-8
        thefuck $TF_PREVIOUS THEFUCK_ARGUMENT_PLACEHOLDER $*
    ) && eval $TF_CMD;
    test -n "$TF_CMD" && print -s $TF_CMD
}

export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

TIPZ_TEXT='💡 '
export VISUAL=nvim
export EDITOR="$VISUAL"

# If NumLock is off, translate keys to make them appear the same as with NumLock on.
bindkey -s '^[OM' '^M'  # enter
bindkey -s '^[Ok' '+'
bindkey -s '^[Om' '-'
bindkey -s '^[Oj' '*'
bindkey -s '^[Oo' '/'
bindkey -s '^[OX' '='

# # If someone switches our terminal to application mode (smkx), translate keys to make
# # them appear the same as in raw mode (rmkx).
bindkey -s '^[OH' '^[[H'  # home
bindkey -s '^[OF' '^[[F'  # end
bindkey -s '^[OA' '^[[A'  # up
bindkey -s '^[OB' '^[[B'  # down
bindkey -s '^[OD' '^[[D'  # left
bindkey -s '^[OC' '^[[C'  # right

# # TTY sends different key codes. Translate them to regular.
bindkey -s '^[[1~' '^[[H'  # home
bindkey -s '^[[4~' '^[[F'  # end

# ZSH Navigation
# Word Navigation
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word

# Home/End
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

# Del
bindkey "^[[3~" delete-char

ulimit -n 256000

export GPG_TTY=$(tty)
