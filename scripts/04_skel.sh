#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "--- 4. Configuration de /etc/skel ---"

# Dossiers utilisateur
mkdir -p /etc/skel/{bin,.local/bin,Bureau,cheatsheets}

# Dotfiles
cp "$REPO_DIR/configs/skel/.bashrc" /etc/skel/.bashrc
cp "$REPO_DIR/configs/skel/.bash_profile" /etc/skel/.bash_profile
cp "$REPO_DIR/configs/skel/.my.cnf" /etc/skel/.my.cnf
chmod 644 /etc/skel/.bashrc /etc/skel/.bash_profile
chmod 400 /etc/skel/.my.cnf

# Aide-mémoires
cp -r "$REPO_DIR/configs/skel/cheatsheets/"* /etc/skel/cheatsheets/
chmod 644 /etc/skel/cheatsheets/*
cp -r /etc/skel/cheatsheets /etc/skel/Bureau/

# Raccourcis sur le Bureau
cat << 'EOF' > /etc/skel/Bureau/phpMyAdmin.desktop
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

cat << 'EOF' > /etc/skel/Bureau/Forgejo.desktop
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

cat << 'EOF' > /etc/skel/Bureau/Projets_Web.desktop
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

chmod +x /etc/skel/Bureau/*.desktop

# Configuration également pour root
cp /etc/skel/.bashrc /root/.bashrc
cp /etc/skel/.bash_profile /root/.bash_profile
cp /etc/skel/.my.cnf /root/.my.cnf
cp -r /etc/skel/cheatsheets /root/cheatsheets

echo "Étape 4 terminée."
