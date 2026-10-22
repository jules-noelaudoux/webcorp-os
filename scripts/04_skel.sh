#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "--- 4. Configuration de /etc/skel ---"

# Dossiers utilisateur et copie de la configuration skel
mkdir -p /etc/skel/{bin,.local/bin,Bureau,cheatsheets}
cp -r "$REPO_DIR/configs/skel/." /etc/skel/

chmod 644 /etc/skel/.bashrc /etc/skel/.bash_profile
chmod 400 /etc/skel/.my.cnf
chmod 644 /etc/skel/cheatsheets/*
chmod +x /etc/skel/Bureau/*.desktop

# Raccourci vers les aide-mémoires sur le Bureau
cp -r /etc/skel/cheatsheets /etc/skel/Bureau/

# Configuration également pour root
cp /etc/skel/.bashrc /root/.bashrc
cp /etc/skel/.bash_profile /root/.bash_profile
cp /etc/skel/.my.cnf /root/.my.cnf
cp -r /etc/skel/cheatsheets /root/cheatsheets

echo "Étape 4 terminée."
