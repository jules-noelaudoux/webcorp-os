# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022
# ~/.bash_profile

# Historique
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoredups:erasedups
shopt -s histappend

# Couleurs Trisquel DevWeb
BG="#0F141C"
SURFACE="#1B2230"
CYAN="\[\e[38;2;0;163;224m\]"
AMBER="\[\e[38;2;229;169;60m\]"
EMERALD="\[\e[38;2;46;204;113m\]"
WHITE="\[\e[38;2;230;237;243m\]"
GRAY="\[\e[38;2;139;148;158m\]"
RESET="\[\e[0m\]"

# Branche Git
parse_git_branch() {
    git branch 2>/dev/null | sed -n '/\* /s///p'
}

# Prompt personnalisé
PS1="${CYAN}\u${RESET}${GRAY}@${RESET}${WHITE}\h${RESET}:${AMBER}\w${RESET} \${parse_git_branch:+${EMERALD}git:(\$(parse_git_branch))${RESET} }\\$ "

# Alias utiles
alias ll='ls -lah --color=auto'
alias la='ls -A --color=auto'
alias l='ls -CF --color=auto'
alias grep='grep --color=auto'
alias sites='cd /var/www/html'
alias backup-now='sudo /usr/local/bin/webcorp-backup.sh'
alias backup-list='sudo /usr/local/bin/webcorp-backup-list.sh'

# Éditeur par défaut
export EDITOR=nano

# Docker
alias dps='docker ps'
alias dc='docker compose'

# NodeJS
alias ni='npm install'
alias nr='npm run'
alias ns='npm start'

# Recharge rapide
alias reload='source ~/.bash_profile'

# Bannière
echo -e "${CYAN}"
echo "╔══════════════════════════════════════╗"
echo "║     TRISQUEL DEVWEB TERMINAL        ║"
echo "╚══════════════════════════════════════╝"
echo -e "${RESET}"

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

if [ -f "$HOME/.atuin/bin/env" ]; then
    . "$HOME/.atuin/bin/env"
fi
