#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "--- 4. Configuration de /etc/skel ---"

mkdir -p /etc/skel/bin /etc/skel/.local/bin
mkdir -p /etc/skel/Desktop /etc/skel/Bureau

# Copie des dotfiles du dépôt vers /etc/skel
cp "$REPO_DIR/configs/skel/.bashrc" /etc/skel/.bashrc
cp "$REPO_DIR/configs/skel/.bash_profile" /etc/skel/.bash_profile
chmod 644 /etc/skel/.bashrc /etc/skel/.bash_profile

# Configuration MariaDB automatique (.my.cnf)
if [ -f "$REPO_DIR/configs/skel/.my.cnf" ]; then
    cp "$REPO_DIR/configs/skel/.my.cnf" /etc/skel/.my.cnf
    chmod 400 /etc/skel/.my.cnf
fi

# Copie des cheatsheets (aide-mémoire HTML/CSS et alias)
if [ -d "$REPO_DIR/configs/skel/cheatsheets" ]; then
    mkdir -p /etc/skel/cheatsheets
    cp -r "$REPO_DIR/configs/skel/cheatsheets/"* /etc/skel/cheatsheets/
    chmod 644 /etc/skel/cheatsheets/*
fi

# Raccourcis sur le Bureau pour la démonstration
for DESKTOP_DIR in "/etc/skel/Desktop" "/etc/skel/Bureau"; do
    mkdir -p "$DESKTOP_DIR"
    if [ -d "$REPO_DIR/configs/skel/cheatsheets" ]; then
        mkdir -p "$DESKTOP_DIR/cheatsheets"
        cp -r "$REPO_DIR/configs/skel/cheatsheets/"* "$DESKTOP_DIR/cheatsheets/"
    fi
    cat << 'EOF' > "$DESKTOP_DIR/phpMyAdmin.desktop"
[Desktop Entry]
Version=1.0
Type=Application
Name=phpMyAdmin
Comment=Administration BDD MariaDB
Exec=abrowser http://localhost/phpmyadmin
Icon=applications-internet
Terminal=false
Categories=Development;
EOF

    cat << 'EOF' > "$DESKTOP_DIR/Forgejo.desktop"
[Desktop Entry]
Version=1.0
Type=Application
Name=Forgejo Git
Comment=Forge logicielle locale
Exec=abrowser http://localhost:3000
Icon=applications-development
Terminal=false
Categories=Development;
EOF

    cat << 'EOF' > "$DESKTOP_DIR/Projets_Web.desktop"
[Desktop Entry]
Version=1.0
Type=Application
Name=Projets Web (/var/www/html)
Comment=Dossier de développement local
Exec=pcmanfm /var/www/html
Icon=system-file-manager
Terminal=false
Categories=Development;
EOF

    chmod +x "$DESKTOP_DIR"/*.desktop 2>/dev/null || true
done

# Copie aussi pour root
cp /etc/skel/.bashrc /root/.bashrc 2>/dev/null || true
cp /etc/skel/.bash_profile /root/.bash_profile 2>/dev/null || true
if [ -f /etc/skel/.my.cnf ]; then
    cp /etc/skel/.my.cnf /root/.my.cnf 2>/dev/null || true
    chmod 400 /root/.my.cnf 2>/dev/null || true
fi
cp -r /etc/skel/cheatsheets /root/cheatsheets 2>/dev/null || true

echo "Configuration de /etc/skel terminée !"
