# ~/.bashrc : exécuté pour les shells interactifs non-login

# Si la session n'est pas interactive, ne rien faire
case $- in
    *i*) ;;
      *) return;;
esac

# Accueil Webcorp
if command -v toilet &>/dev/null; then
    toilet -w 100 WEBCORP
fi
echo "Bonjour $USER - Session de développement Webcorp"
echo ""

# Gestion de l'historique
HISTCONTROL=ignoreboth:erasedups
shopt -s histappend
HISTSIZE=2000
HISTFILESIZE=5000

# Adapter la taille d'affichage aux changements de fenêtre
shopt -s checkwinsize

# Support des fichiers compressés pour less
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Détection de chroot éventuel
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Fonction pour afficher la branche Git courante
parse_git_branch() {
    git branch 2>/dev/null | sed -n '/* /s///p'
}

# Couleurs du thème Webcorp
CYAN="\[\e[38;2;0;163;224m\]"
AMBER="\[\e[38;2;229;169;60m\]"
EMERALD="\[\e[38;2;46;204;113m\]"
WHITE="\[\e[38;2;230;237;243m\]"
GRAY="\[\e[38;2;139;148;158m\]"
RESET="\[\e[0m\]"

# Invite de commande (prompt) personnalisée avec branche Git
GIT_PROMPT="\$(b=\$(parse_git_branch); [ -n \"\$b\" ] && echo \" ${EMERALD}git:(\$b)${RESET}\")"
PS1="${CYAN}\u${RESET}${GRAY}@${RESET}${WHITE}\h${RESET}:${AMBER}\w${RESET}${GIT_PROMPT} \$ "

# Titre du terminal xterm
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# Couleurs pour ls
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# --- Alias Webcorp ---

# Navigation et listes
alias ll='ls -lah --color=auto'
alias la='ls -A --color=auto'
alias l='ls -CF --color=auto'
alias sites='cd /var/www/html'

# Sauvegarde chiffrée (Restic)
alias backup-now='sudo /usr/local/bin/webcorp-backup.sh'
alias backup-list='sudo /usr/local/bin/webcorp-backup-list.sh'

# Recharger la configuration du terminal
alias reload='source ~/.bashrc'

# Alias personnels dans ~/.bash_aliases s'il existe
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Autocomplétion bash
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
