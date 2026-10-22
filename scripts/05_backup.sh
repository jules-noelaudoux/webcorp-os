#!/bin/bash

#coupe le programme à la moindre erreur
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "--- 5. Configuration de la sauvegarde chiffrée (Restic) ---"

mkdir -p /var/backups/webcorp-restic /etc/webcorp

# Configuration Restic
cp "$REPO_DIR/configs/backup/backup.env" /etc/webcorp/backup.env
chmod 600 /etc/webcorp/backup.env

# Scripts de sauvegarde
cp "$REPO_DIR/configs/bin/webcorp-backup.sh" /usr/local/bin/webcorp-backup.sh
cp "$REPO_DIR/configs/bin/webcorp-backup-list.sh" /usr/local/bin/webcorp-backup-list.sh
chmod 755 /usr/local/bin/webcorp-backup.sh /usr/local/bin/webcorp-backup-list.sh

# Raccourcis dans le PATH pour les commandes backup
ln -sf /usr/local/bin/webcorp-backup.sh /usr/local/bin/backup-now
ln -sf /usr/local/bin/webcorp-backup-list.sh /usr/local/bin/backup-list

# Service et Timer systemd
cp "$REPO_DIR/configs/systemd/webcorp-backup.service" /etc/systemd/system/webcorp-backup.service
cp "$REPO_DIR/configs/systemd/webcorp-backup.timer" /etc/systemd/system/webcorp-backup.timer

systemctl daemon-reload 2>/dev/null || true
systemctl enable webcorp-backup.timer 2>/dev/null || true

echo "Étape 5 terminée."
