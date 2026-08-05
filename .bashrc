# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# append to the history file, don't overwrite it
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

#CUDA
export CUDA_PATH="/usr/local/cuda"
export PATH="${CUDA_PATH}/bin:${PATH}"
export LD_LIBRARY_PATH="${CUDA_PATH}/lib64:${LD_LIBRARY_PATH}"
export CUDACXX="${CUDA_PATH}/bin/nvcc"
export CUDA_TOOLKIT_ROOT_DIR="${CUDA_PATH}"
export CUDA_BIN_PATH="${CUDA_PATH}/bin"

# ignore duplicates in bash history
export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=100000
export HISTFILESIZE=100000

. "$HOME/.cargo/env"

# Use red color for stderr when this command (Usage: color <command>)
color()(set -o pipefail;"$@" 2> >(sed $'s,.*,\e[31m&\e[m,'>&2))

if [ -e ~/.bashrc_extras.sh ]; then
  source ~/.bashrc_extras.sh
fi

if ! [[ -n "${WINDOWS_USER}" ]]; then
  echo  "Warning: WINDOWS_USER not set. Set it in bashrc_extras.sh in your home folder"
fi

alias d="cd /mnt/c/Users/${WINDOWS_USER}/Desktop/"
alias ex="explorer.exe ."
alias gits="git status"
alias vim=nvim
alias ex="explorer.exe ."
alias tf="terraform"
alias k="fc -s"

#add clang to path
export PATH="/opt/clang+llvm/bin:${PATH}"

# append to bash history immediately
shopt -s histappend
PROMPT_COMMAND="history -a;$PROMPT_COMMAND"
export EDITOR="/bin/nvim"

# Download consolas nerd font: https://github.com/wclr/my-nerd-fonts/blob/master/Consolas%20NF/Consolas%20Nerd%20Font%20Complete%20Mono%20Windows%20Compatible.ttf

export KUBE_EDITOR="nvim"
export EDITOR="nvim"
export BROWSER=wslview

ulimit -c 0

. <(kubectl completion bash)  # completion for kubectl

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PYTHONBREAKPOINT="ipdb.set_trace"

export PATH="/home/${USER}/.nvm/versions/node/v23.1.0/lib/node_modules:${PATH}"

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

eval "$(/home/${USER}/.local/bin/mise activate bash)"
eval "$(mise completion bash --include-bash-completion-lib)"
eval "$(fzf --bash)"
alias gitam="git commit --am --no-edit"

if [ -e "${HOME}/.local/share/mise/installs/task/latest/completion/bash/task.bash" ]; then
  source "${HOME}/.local/share/mise/installs/task/latest/completion/bash/task.bash"
fi

if [ "${PWD,,}" == "/mnt/c/windows/system32" ]; then
  cd "$HOME"
fi

source "${HOME}/scripts/uv_completions.sh"
source "/usr/share/bash-completion/completions/git"

export PS1="(\t) \[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "

export PATH="$PATH:/home/${USER}/.dotnet/tools"

bind 'set show-all-if-ambiguous on'  # Show all completions on first tab, if there are multiple possibilities
bind 'TAB:complete'
# Empty line: no completion
complete -E -W ''
# First word: nothing for 0-1 chars; 2+ chars -> command completion, PATH scan capped at 300ms
_min2_firstword() {
    local cur="$2"
    (( ${#cur} < 2 )) && { COMPREPLY=(); return 0; }
    mapfile -t COMPREPLY < <(
        {
            # instant, in-memory sources (never timed out)
            compgen -a -b -k -A function -- "$cur"
            # potentially slow PATH scan, killed after 300ms
            timeout 0.3s bash -c 'compgen -c -- "$1"' _ "$cur"
        } | sort -u
    )
    return 0
}
complete -I -F _min2_firstword
