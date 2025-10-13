#!/usr/bin/env zsh
#set -x
#######################################################################
# Pre-scripts
#######################################################################
#Start Tmux as the default Shell for user
if [[ -x "$(command -v tmux)" ]] && [[ -n "${PS1}" ]] && [[ -z "${TMUX}" ]]; then
    case "$(readlink -f /proc/${PPID}/exe)" in
    *dolphin* | *jetbrain* | *plasmashell* | *konsole*) ;;
    *)
        exec tmux
        ;;
    esac
fi

# yazi shell wrapper
function yy() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/cc/anaconda3/bin/conda' 'shell.zsh' 'hook' 2>/dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/cc/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/cc/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/cc/anaconda3/bin:$PATH"
    fi
fi
# <<< conda initialize <<<

#######################################################################
# Environments
#######################################################################
#TERM=xterm-256color
# Theme
ZSH_THEME="half-life"
#ZSH_THEME="bira"

# History Settings
HISTFILE=~/.zhistory
HISTSIZE=4096
SAVEHIST=4096
#export SSLKEYLOGFILE=/tmp/keylogfile.txt

# Enviroment Virables
export ZSH="/home/${USER}/.oh-my-zsh"
# It will cause less to launch subl in editor mod which is unexpected
# But if use bat instead of less it's not matter cause bat do not support editor mod right now
#export VISUAL="/usr/bin/subl"
export VISUAL="/usr/bin/nvim"
export EDITOR="/usr/bin/nvim"
export UPDATE_ZSH_DAYS=30
export LANG=en_US.UTF-8
export FZF_BASE=/usr/share/fzf
# Set w3m as the default browser for web-search plugin
export BROWSER="w3m"

#######################################################################
# Plugins
#######################################################################
# >>>> Built-in plugins (start)
plugins=(
    conda-zsh-completion
    colored-man-pages
    command-not-found
    extract
    fancy-ctrl-z
    fzf
    fzf-tab
    gh
    git
    sudo
    themes
    web-search
)
# <<<< Built-in plugins (end)

# >>>> Extra plugins (start)
eval "$(fzf --zsh)"
eval "$(thefuck --alias)"
eval "$(zoxide init zsh)"
# fasd is archived now
#eval "$(fasd --init auto)"
# Use control + g to activate navi
#eval "$(navi widget zsh)"
fpath+=/usr/share/zsh/plugins/zsh-completions/src
[ -f /usr/share/zsh/plugins/zsh-autopair/autopair.zsh ] && source /usr/share/zsh/plugins/zsh-autopair/autopair.zsh
[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# Use up-arrow or down-arrow to show candidate suggestions
# Use right-arrow to accept the suggestion
[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
[ -f $ZSH/oh-my-zsh.sh ] && source $ZSH/oh-my-zsh.sh
autopair-init
# <<<< Extra plugins (end)

# Implemented in zsh-completions
# >>>> Vagrant command completion (start)
# fpath+=/opt/vagrant/embedded/gems/gems/vagrant-2.4.0/contrib/zsh
# compinit
# <<<<  Vagrant command completion (end)

# pip zsh completion start
#compdef -P pip[0-9.]#
__pip() {
    compadd $(COMP_WORDS="$words[*]" \
        COMP_CWORD=$((CURRENT - 1)) \
        PIP_AUTO_COMPLETE=1 $words[1] 2>/dev/null)
}
if [[ $zsh_eval_context[-1] == loadautofunc ]]; then
    # autoload from fpath, call function directly
    __pip "$@"
else
    # eval/source/. command, register function for later
    compdef __pip -P 'pip[0-9.]#'
fi
# pip zsh completion end

#######################################################################
# Custom scripts
#######################################################################
#fastfetch
[[ ! "$(readlink -f /proc/${PPID}/exe)" =~ "jetbrain" ]] && [[ -z "${ASCIINEMA_REC}" ]] && [[ -x "$(command -v fastfetch)" ]] && fastfetch --disable-linewrap

# Print a new line after command excuted
precmd() {
    print ""
}

# Use gpg-agent instead of ssh-agent
unset SSH_AGENT_PID
if [[ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]]; then
    export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi
export GPG_TTY=${TTY:-"$(tty)"}
gpg-connect-agent updatestartuptty /bye >/dev/null

#######################################################################
# Bindings
# Use keybind command to list all bindings
# Use showkey -a command to listen keystrokes
# ^ equal to ctrl
# ^[ equal to escape or alt
#######################################################################
# Movement
#bindkey -M main '^H' backward-char
#bindkey -M main '^L' forward-char
bindkey -M main '^B' backward-word
bindkey -M main '^F' forward-word
bindkey -M main '^A' beginning-of-line
bindkey -M main '^E' end-of-line

# Modifiying text
#bindkey -M main '' backward-delete-char
#bindkey -M main '' delete-char
bindkey -M main '^W' backward-kill-word
bindkey -M main '^D' kill-word
bindkey -M main '^U' backward-kill-line
bindkey -M main '^K' kill-line
bindkey -M main '^G' kill-whole-line
bindkey -M main '^Y' yank

# History
bindkey -M main '^P' history-search-backward
bindkey -M main '^N' history-search-forward
bindkey -M main '^H' fzf-history-widget
bindkey -M main '^Q' fzf-file-widget

bindkey -M main '^M' accept-line
bindkey -M main '^L' clear-screen
bindkey -M main '^T' quote-line
bindkey -M main '^Z' fancy-ctrl-z
bindkey -M main '^[^[' sudo-command-line

#######################################################################
# Aliases
#######################################################################
# >>>> Built-in aliases (start)
alias c='clear'
alias ls='lsd'
alias ll='ls -l'
alias la='ls -a'
alias lt='ls --tree'
alias lla='ll -a'
alias llt='ll --tree'
alias lat='la --tree'
alias lta='lat'
alias llat='llt -a'
alias llta='llat'
alias ln='ln -v'
#alias top='btop'
alias cat='bat -pp'
alias less='bat --pager "less -i"'
alias more='bat --pager "less -i"'
alias watch='viddy'
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
#alias n='navi'
alias nc='ncat'
#With -C it will be export ANSI color code if redirect to files
#alias jq='jq -C'
alias lynx='lynx -display_charset=utf-8'
alias gitm='gitmoji'
alias lg='lazygit'
alias w3m='w3m https://duckduckgo.com'
alias fzf='fzf --reverse --border --highlight-line'
alias trz='trans zh:en'
alias tre='trans en:zh'
alias shc='steghide embed'
alias shx='steghide extract'
alias shi='steghide info'
alias bwh='bandwhich'
alias vbox='VirtualBox %U'
alias vag='vagrant'
alias geeq='geeqie'
alias gshark='wireshark'
alias typo='typora'
#alias yy='yazi'
alias vim='nvim'
alias wbs='web_search duckduckgo'
alias ytd='yt-dlp'
alias rdm='remotedesktopmanager'
alias xfreerdp='xfreerdp /cert:tofu /fonts /bpp:64 /video /dynamic-resolution /scale:140 /scale-desktop:125'
# Alias for logout KDE plasma with cancel menu
alias logout="qdbus org.kde.LogoutPrompt /LogoutPrompt org.kde.LogoutPrompt.promptLogout"
alias icat="kitten icat"
alias issh="kitten ssh"
# <<<< Extra aliases (end)

# >>>> File assosicated aliases (start)
alias -s {json,yaml,yml,txt}=subl
alias -s {mp4,webm,avi}=vlc
alias -s {png,jpeg,jpg}=geeqie
alias -s {xlsx,cvs}=libreoffice --calc
alias -s docs=libreoffice --writer
alias -s ppt=libreoffce --impress
alias -s pdf=okular
alias -s md=typora
alias -s html=zen-browser
# <<<< File assosicated aliases (end)

# Crack jetbrains' IDE
___MY_VMOPTIONS_SHELL_FILE="${HOME}/.jetbrains.vmoptions.sh"
if [ -f "${___MY_VMOPTIONS_SHELL_FILE}" ]; then . "${___MY_VMOPTIONS_SHELL_FILE}"; fi
