# ~/.bash_profile : exécuté pour les shells de connexion (login shells)

# Variables d'environnement
export EDITOR=nano

# Ajout des dossiers privés de l'utilisateur au PATH s'ils existent
if [ -d "$HOME/bin" ]; then
    PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ]; then
    PATH="$HOME/.local/bin:$PATH"
fi

export PATH

# Charger ~/.bashrc pour les sessions interactives
if [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi
