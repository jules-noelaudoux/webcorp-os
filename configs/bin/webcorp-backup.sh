#!/bin/bash
set -e

[ "$EUID" -ne 0 ] && exec sudo "$0" "$@"

source /etc/webcorp/backup.env
export RESTIC_REPOSITORY RESTIC_PASSWORD

echo "--- Sauvegarde Webcorp (Restic) ---"

# Export SQL
mariadb-dump --all-databases > /var/backups/dump_mariadb.sql 2>/dev/null || true

# Initialisation du dépôt si premier lancement
restic snapshots &>/dev/null || restic init

# Sauvegarde des projets, configurations et bases de données
restic backup /var/www/html /etc/apache2 /etc/php /var/lib/forgejo /home /var/backups/dump_mariadb.sql 2>/dev/null || \
restic backup /var/www/html /etc/apache2 /home

# Rétention : 7 jours et 4 semaines
restic forget --keep-daily 7 --keep-weekly 4 --prune || true

rm -f /var/backups/dump_mariadb.sql
echo "Sauvegarde terminée le $(date)"
