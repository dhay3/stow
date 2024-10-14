#!/usr/bin/env bash

case $- in
*i*) ;;
*) return ;;
esac

#######################################################################
# Environments
#######################################################################
# Theme
OSH_THEME="agnoster"
OMB_USE_SUDO=true
OMB_DEFAULT_ALIASES="check"
DISABLE_AUTO_UPDATE="true"
# Print a new line after commands executed
PROMPT_COMMAND="echo"

# History Settings
HISTFILE=~/.bash_history
HISTSIZE=4096
SAVEHIST=4096

export OSH='/home/cc/.oh-my-bash'
export VISUAL="/usr/bin/vim"
export EDITOR="/usr/bin/vim"
export LANG=en_US.UTF-8

source "$OSH"/oh-my-bash.sh

#######################################################################
# Plugins and Completions
#######################################################################
plugins=(
  git
)

completions=(
  docker
  git
  gh
  go
  pip
  pip3
  ssh
  tmux
)

eval "$(thefuck --alias)"
eval "$(zoxide init bash)"

# >>>> Vagrant command completion (start)
source /opt/vagrant/embedded/gems/gems/vagrant-2.4.1/contrib/bash/completion.sh
# <<<<  Vagrant command completion (end)

#######################################################################
# Custom scripts
#######################################################################
#fastfetch
[[ ! "$(readlink -f /proc/${PPID}/exe)" =~ "jetbrain" ]] && [[ -x "$(command -v fastfetch)" ]] && fastfetch --disable-linewrap

# Use gpg-agent instead of ssh-agent
unset SSH_AGENT_PID
if [[ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]]; then
  export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi
export GPG_TTY=${TTY:-"$(tty)"}
gpg-connect-agent updatestartuptty /bye >/dev/null

#######################################################################
# Aliases
#######################################################################
# >>>> Built-in aliases (start)
alias c='clear'
alias ls='lsd'
alias l='ll'
alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'
alias ln='ln -v'
#alias top='btop'
alias cat='bat -pp'
alias less='bat --pager "less -i"'
alias more='bat --pager "less -i"'
#alias man='man -P less'
#alias grep='rg'
#alias find='fd'
# Recursive copy will create a dirctory name of the source, it should be trailing slash on the source to copy the contents of the directoy
#alias cp='rsync --progress -azvh'
alias cp='cp -v'
alias mkdir='mkdir -v'
alias mk='mkdir -v'
alias mv='mv -v'
# It is better do not use trash-put
alias rm='trash-put -v'
#alias rm='rm -v'
alias du='dust'
#alias du='du -h'
alias df='duf'
#alias df='df -h'
#alias ps='procs'
alias free='free -h'
alias ip='ip -c=always'
alias diff='diff --color=auto'
alias dmesg='dmesg --color=always'
alias split='split --verbose'
alias pacman='pacman --color always'
# <<<< Built-in aliases (end)

# >>>> Extra aliases (start)
alias n='navi'
alias nc='ncat'
alias jq='jq -C'
alias lynx='lynx -display_charset=utf-8'
alias gitm='gitmoji'
alias fzf='fzf --reverse'
alias vbox='VirtualBox %U'
alias vag='vagrant'
alias geeq='geeqie'
alias wirek='wireshark'
alias typo='typora'
alias rag='ranger'
alias wbs='web_search duckduckgo'
alias ytd='yt-dlp'
alias rdm='remotedesktopmanager'
alias xfreerdp='xfreerdp /cert:tofu /fonts /bpp:64 /video /dynamic-resolution /scale:140 /scale-desktop:125'
# Alias for logout KDE plasma with cancel menu
alias logout="qdbus org.kde.LogoutPrompt /LogoutPrompt org.kde.LogoutPrompt.promptLogout"
# <<<< Extra aliases (end)

___MY_VMOPTIONS_SHELL_FILE="${HOME}/.jetbrains.vmoptions.sh"
if [ -f "${___MY_VMOPTIONS_SHELL_FILE}" ]; then . "${___MY_VMOPTIONS_SHELL_FILE}"; fi
